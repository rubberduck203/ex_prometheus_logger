defmodule CowboyExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :cowboy_example,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :prometheus_plugs],
      mod: {CowboyExample.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:prometheus_plugs, "~> 1.1.1"}
    ]
  end
end
