defmodule ExBitmex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_bitmex,
      version: "0.3.0",
      elixir: "~> 1.7",
      package: package(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.1"},
      {:mapail, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:mock, "~> 0.3", only: :test},
      {:exvcr, "~> 0.10", only: [:dev, :test]},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:websockex, "~> 0.4"}
    ]
  end

  defp description do
    "BitMEX API Client for Elixir"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-capital/ex_bitmex"}
    }
  end
end
