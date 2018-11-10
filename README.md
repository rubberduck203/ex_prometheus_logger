# ExPrometheusLogger

ExPrometheusLogger is a [custom Elixir logger backend](https://hexdocs.pm/logger/Logger.html#module-custom-backends).
It creates counters and increments them on logging events, providing easy insight into the number of warning & errors occuring in your applications.

![`ex_logger`: Rising counts of errors and warnings](img/count.png)

![`rate(ex_logger[30s])`: Rate of increase per second of warnings and errors](img/rate.png)

## Installation

### mix.exs

```elixir
def deps do
  [
    {:prometheus_logger, git: "https://github.com/rubberduck203/ex_prometheus_logger.git", tag: "0.1.1"},
  ]
```

<!--
If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `prometheus_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:prometheus_logger, "~> 0.1.1"}
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
    extra_applications: [:prometheus, :logger]
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

## Exposing Metrics

ExPrometheusLogger doesn't actually publish the metrics.
It just creates and increments [prometheus_ex counters](https://hexdocs.pm/prometheus_ex/Prometheus.Metric.Counter.html#content).

It's the user's responsibility to expose those metrics,
either by [exposing a `/metrics` endpoint](https://medium.com/@brucepomeroy/publishing-metrics-to-prometheus-from-elixir-bb70efcd6ec1)
or by using the [pushgateway](https://github.com/deadtrickster/prometheus-push).

See the [example](example/) directory for examples of how to use [pushgateway](example/pushgateway) and [Cowboy & Plug](example/cowboy) to publish the metrics.

## Alerting

The logger backend uses a `counter` to collect the number of times different level logging events have occured.
Because this is a counter, to set up an alert, it us recommended to use the [`rate()`](https://prometheus.io/docs/prometheus/latest/querying/functions/#rate) function to calculate the rate errors/warnings are *increasing* over a period of time.

```prometheus
rate(
  ex_logger{level="error"}[1m]
)
```

See [example/rules.yml](example/rules.yml) for sample alerting rules.

There are times you may want to alert on a hard number of log messages.
That should be a relatively rare, but straight forward, use case.

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
