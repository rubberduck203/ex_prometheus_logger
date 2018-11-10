# ExPrometheusLogger

ExPrometheusLogger is a [custom Elixir logger backend](https://hexdocs.pm/logger/Logger.html#module-custom-backends).
It creates counters and increments them on logging events, providing easy insight into the number of warning & errors occuring in your applications.

ExPrometheusLogger doesn't actually publish the metrics.
It just creates and increments [prometheus_ex counters](https://hexdocs.pm/prometheus_ex/Prometheus.Metric.Counter.html#content).

It's the user's responsibility to expose those metrics,
either by [exposing a `/metrics` endpoint](https://medium.com/@brucepomeroy/publishing-metrics-to-prometheus-from-elixir-bb70efcd6ec1)
or by using the [pushgateway](https://github.com/deadtrickster/prometheus-push).

See the [example](example/) directory for examples of how to use [pushgateway](example/pushgateway) and [Cowboy & Plug](example/cowboy) to publish the metrics.

## Installation

### mix.exs

```elixir
def deps do
  [
    {:prometheus_logger, git: "https://github.com/rubberduck203/ex_prometheus_logger.git", tag: "0.1.0"},
  ]
```

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

#### config.exs

```elixir
config :logger,
  backends: [:console, Logger.Backends.Prometheus]
```

and ensure that `:prometheus` is started before `:logger`.

#### mix.exs

```elixir
def application do
  [
    # :prometheus *must* be started before :logger
    applications: [:prometheus, :logger]
  ]
end
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

- [x] Provide examples for using
   - [x] Pushgateway
   - [x] Exposing a `/metrics` endpoint
- [ ] Use pushgateway automatically if `:prometheus, :pushgateway` config is present in app env.
- [ ] Publish on Hex
- [ ] Publish docs
- [ ] Travis CI build/release
- [ ] Custom labels?
- [ ] Take `:logger, :level` into consideration
- [ ] Leverage logger meta-data?
