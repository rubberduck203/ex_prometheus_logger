# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger,
  backends: [:console, Logger.Backends.Prometheus]

config :logger, Logger.Backends.Prometheus, level: :debug

config :prometheus,
  pushgateway: [address: "http://localhost:9091"]
