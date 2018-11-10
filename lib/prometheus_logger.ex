defmodule Logger.Backends.Prometheus do
  @moduledoc false

  @behaviour :gen_event

  use Prometheus.Metric

  def hostname do
    with {:ok, hostname} <- :inet.gethostname() do
      hostname
      |> to_string()
      |> String.trim()
    end
  end

  ## Logger implementation

  @name :ex_logger

  def init(_args) do
    Counter.declare(
      name: @name,
      help: "Logged message count by level.",
      labels: [:instance, :level]
    )

    backend_env = Application.get_env(:logger, __MODULE__, [level: :warn])
    {:ok, backend_env}
  end

  def handle_event({level, _group_leader, {Logger, _message, _timestamp, _metadata}}, state) do
    case Logger.compare_levels(level, Keyword.get(state, :level)) do
      :lt -> nil
      _ -> Counter.inc(name: @name, labels: [hostname(), level])
    end

    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  def handle_call({:configure, options}, state) do
    {:ok, :ok, Keyword.merge(state, options)}
  end

end
