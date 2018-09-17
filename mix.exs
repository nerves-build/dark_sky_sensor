defmodule DarkSkySensor.MixProject do
  use Mix.Project

  def project do
    [
      app: :dark_sky_sensor,
      version: "0.5.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DarkSkySensor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic_sensor, "~> 0.7.0"},
      {:httpoison, "~> 1.0"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:poison, "~> 3.1"}
    ]
  end
end
