# CowboyExample

Example of using Plug & Cowboy to expose a `/metrics` endpoint for an application that otherwise wouldn't have an HTTP server.

All of the magic happens in [lib/cowboy_example/application.ex](lib/cowboy_example/application.ex) and [config/config.exs](config/config.exs).

You're going to want to reference the [Plug](https://hexdocs.pm/plug/readme.html) and [Prometheus Plug](https://hexdocs.pm/prometheus_plugs/Prometheus.PlugExporter.html) documentation.

```bash
iex -S mix
```

```elixir
iex> require Logger
:ok
iex> Logger.warn "danger!"
:ok
iex> Logger.error "boom!"
:ok
```

```bash
## in a different terminal

# to see all available metrics
curl http://localhost:4000/metrics

# to filter on just ex_logger metrics
curl http://localhost:4000/metrics 2>/dev/null | grep ex_logger
```