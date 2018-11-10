# Example

See [config/config.exs](config/config.exs) for an example configuration.
[lib/example.ex](lib/example.ex) shows how to use the push gateway to publish Prometheus metrics.

The easiest way to run the example is to start a Prometheus Pushgatway docker container.

```bash
docker run -d -p 9091:9091 prom/pushgateway
iex -S mix
```

```elixir
iex> require Logger
:ok
iex> Logger.warn "danger!"
:ok
iex> Logger.error "boom!"
:ok
iex> Prometheus.Push.push(%{job: "example_job", grouping_key: []})
:ok
```