use Mix.Config

config :logger,
  backends: [:console, Logger.Backends.Prometheus]