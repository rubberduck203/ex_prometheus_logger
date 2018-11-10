defmodule PrometheusLogger.MixProject do
  use Mix.Project

  def project do
    [
      app: :prometheus_logger,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # :prometheus *must* be started before :logger
      extra_applications: [:prometheus, :logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:prometheus_ex, "~> 3.0"}
    ]
  end
end
