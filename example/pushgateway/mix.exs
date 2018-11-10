defmodule Example.MixProject do
  use Mix.Project

  def project do
    [
      app: :example,
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
      {:prometheus_logger, git: "https://github.com/rubberduck203/ex_prometheus_logger.git", tag: "0.1.1"},
      # {:prometheus_logger, path: "../../"},
      {:prometheus_ex, "~> 3.0", override: true},
      {:prometheus_push, "~> 0.0.1"}
    ]
  end
end
