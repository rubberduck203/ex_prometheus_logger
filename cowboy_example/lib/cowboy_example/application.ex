# Define a metrics exporter plug
defmodule CowboyExample.MetricsExporter do
  use Prometheus.PlugExporter
end

defmodule CowboyExample.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Setup our exporter & metrics
    CowboyExample.MetricsExporter.setup()

    # Have the application supervisor our plug directly
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: CowboyExample.MetricsExporter, options: [port: 4000])
    ]

    opts = [strategy: :one_for_one, name: CowboyExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

