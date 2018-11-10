# CowboyExample

Example of using Plug & Cowboy to expose a `/metrics` endpoint for an application that otherwise wouldn't have an HTTP server.

All of the magic happens in [lib/cowboy_example/application.ex](lib/cowboy_example/application.ex).

You're going to want to reference the [Plug](https://hexdocs.pm/plug/readme.html) and [Prometheus Plug](https://hexdocs.pm/prometheus_plugs/Prometheus.PlugExporter.html) documentation.

```bash
mix run --no-halt
curl http://localhost:4000/metrics
```