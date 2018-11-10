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
      extra_applications: [:prometheus, :prometheus_plugs, :logger],
      mod: {CowboyExample.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:prometheus_plugs, "~> 1.1.1"},
      {:prometheus_logger, git: "https://github.com/rubberduck203/ex_prometheus_logger.git", tag: "0.1.1"},
      # {:prometheus_logger, path: "../../"}
    ]
  end
end
