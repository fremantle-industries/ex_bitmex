defmodule ExBitmex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_bitmex,
      version: "0.0.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
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
      {:httpoison, "~> 1.4.0"},
      {:jason, "~> 1.1.0"},
      {:mapail, "~> 1.0.2"},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:exvcr, "~> 0.10.0", only: [:dev, :test]},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
