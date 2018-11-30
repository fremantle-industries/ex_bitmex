defmodule ExBitmex.Auth do
  @nonce_shift 1_484_899_880_000_000

  def sign(api_secret, verb, encoded_path, nonce, data) do
    payload = verb <> encoded_path <> to_string(nonce) <> data
    :sha256 |> :crypto.hmac(api_secret, payload) |> Base.encode16(case: :lower)
  end

  def nonce, do: :os.system_time(:micro_seconds) - @nonce_shift
end
