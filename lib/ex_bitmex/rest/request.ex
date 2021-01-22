defmodule ExBitmex.Rest.Request do
  @type path :: String.t()
  @type credentials :: ExBitmex.Credentials.t()
  @type params :: map
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type message :: String.t()
  @type bad_request :: {:bad_request, error :: map}
  @type forbidden :: {:forbidden, message}
  @type unauthorized :: {:unauthorized, message}
  @type service_unavailable :: {:service_unavailable, message}
  @type nonce_not_increasing :: {:nonce_not_increasing, message}
  @type auth_error_reason ::
          :timeout
          | :connect_timeout
          | :non_existent_domain
          | :not_found
          | bad_request
          | :rate_limited
          | :overloaded
          | :bad_gateway
          | service_unavailable
          | nonce_not_increasing
          | :ip_forbidden
          | forbidden
          | :invalid_signature
          | unauthorized
  @type auth_error_response :: {:error, auth_error_reason, rate_limit | nil}
  @type auth_success_response :: {:ok, map | [map], rate_limit}
  @type auth_response :: auth_success_response | auth_error_response
  @type non_auth_error_reason ::
          :timeout
          | :not_found
          | bad_request
          | :overloaded
          | service_unavailable
  @type non_auth_response ::
          {:ok, map | [map], rate_limit} | {:error, non_auth_error_reason, rate_limit | nil}

  def send(request) do
    request
    |> HTTPoison.request()
    |> parse_rate_limits
    |> parse_response
  end

  @limit_header "x-ratelimit-limit"
  @remaining_header "x-ratelimit-remaining"
  @reset_header "x-ratelimit-reset"

  defp parse_rate_limits({result, %HTTPoison.Response{headers: headers} = response}) do
    limit_headers =
      headers
      |> Enum.reduce(
        %{},
        fn {k, v}, acc ->
          case String.downcase(k) do
            @limit_header -> Map.put(acc, :limit, v)
            @remaining_header -> Map.put(acc, :remaining, v)
            @reset_header -> Map.put(acc, :reset, v)
            _ -> acc
          end
        end
      )

    rate_limit = limit_headers |> build_rate_limit
    {result, response, rate_limit}
  end

  defp parse_rate_limits({result, %HTTPoison.Error{} = error}) do
    {result, error, nil}
  end

  defp build_rate_limit(%{limit: limit, remaining: remaining, reset: reset}) do
    %ExBitmex.RateLimit{
      limit: limit |> String.to_integer(),
      remaining: remaining |> String.to_integer(),
      reset: reset |> String.to_integer()
    }
  end

  defp build_rate_limit(%{}), do: nil

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}, rate_limit}) do
    json = body |> Jason.decode!()
    {:ok, json, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 400, body: body}, rate_limit}) do
    json = Jason.decode!(body)

    message =
      json
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    reason =
      if message =~ "Nonce is not increasing" do
        {:nonce_not_increasing, message}
      else
        {:bad_request, json}
      end

    {:error, reason, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 401, body: body}, rate_limit}) do
    message =
      body
      |> Jason.decode!()
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    reason =
      if message == "Signature not valid." do
        :invalid_signature
      else
        {:unauthorized, message}
      end

    {:error, reason, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 403, body: body}, rate_limit}) do
    message =
      body
      |> Jason.decode!()
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    reason =
      if message == "This IP address is not allowed to use this key." do
        :ip_forbidden
      else
        {:forbidden, message}
      end

    {:error, reason, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 404}, rate_limit}) do
    {:error, :not_found, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 429}, rate_limit}) do
    {:error, :rate_limited, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 502}, rate_limit}) do
    {:error, :bad_gateway, rate_limit}
  end

  defp parse_response({
         :ok,
         %HTTPoison.Response{status_code: 503, body: body},
         rate_limit
       }) do
    message =
      body
      |> Jason.decode!()
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    reason =
      if message =~ "The system is currently overloaded" do
        :overloaded
      else
        {:service_unavailable, message}
      end

    {:error, reason, rate_limit}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: :timeout}, nil}) do
    {:error, :timeout, nil}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: :connect_timeout}, nil}) do
    {:error, :connect_timeout, nil}
  end

  @non_existent_domain [:nxdomain, "nxdomain"]
  defp parse_response({:error, %HTTPoison.Error{reason: reason}, nil})
       when reason in @non_existent_domain do
    {:error, :non_existent_domain, nil}
  end
end
