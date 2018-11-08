# ExPrometheusLogger

ExPrometheusLogger is a [custom Elixir logger backend](https://hexdocs.pm/logger/Logger.html#module-custom-backends).
It creates counters and increments them on logging events.

ExPrometheusLogger doesn't actually publish the metrics.
It just creates and increments [prometheus_ex counters](https://hexdocs.pm/prometheus_ex/Prometheus.Metric.Counter.html#content).

It's the user's responsibility to expose those metrics,
either by [exposing a `/metrics` endpoint](https://medium.com/@brucepomeroy/publishing-metrics-to-prometheus-from-elixir-bb70efcd6ec1)
or by using the [pushgateway](https://github.com/deadtrickster/prometheus-push).

## Installation

<!--
If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `prometheus_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:prometheus_logger, "~> 0.1.0"}
  ]
end
```
-->

### Configuration

Just add the logger backend to your config

```elixir
config :logger,
  backends: [:console, Logger.Backends.Prometheus]
```

Currently, the only supported configuration is the log level.
It defaults to `:warn`.
Setting or changing the base logger level has no effect on ExPrometheusLogger's level.

```
config :logger, Logger.Backends.Prometheus,
  level: :warn
```

<!--
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/prometheus_logger](https://hexdocs.pm/prometheus_logger).
-->

## Roadmap

In no particular order...

1. Provide examples for using the Pushgateway and exposing a `/metrics` endpoint.
2. Use [logger metadata][meta-data] to supply an application label for the metrics.
3. Support labels in general. Maybe read them from user config.