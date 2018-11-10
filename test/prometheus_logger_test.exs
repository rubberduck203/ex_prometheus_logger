defmodule Logger.Backends.PrometheusTest do
  use ExUnit.Case
  require Prometheus.Metric.Counter
  alias Prometheus.Metric.Counter, as: Counter
  alias Logger.Backends.Prometheus, as: PLogger

  doctest Logger.Backends.Prometheus

  @timestamp {{2018, 11, 3}, {10, 29, 10, 124}}
  @hostname PLogger.hostname()

  setup do
    PLogger.init(nil)

    on_exit(fn ->
      [:debug, :info, :warn, :error]
      |> Enum.map(&Counter.remove(name: :ex_logger, labels: [@hostname, &1]))
    end)
  end

  describe "init" do
    test "Creates warning counter" do
      assert :undefined == Counter.value(name: :ex_logger, labels: [@hostname, :warn])
    end

    test "Creates error counter" do
      assert :undefined == Counter.value(name: :ex_logger, labels: [@hostname, :error])
    end

    test "default log level is warn" do
      {:ok, [level: :warn]} = Logger.Backends.Prometheus.init(nil)
    end
  end

  describe "handle_call/2" do
    test "Can change the log level" do
      state = [level: :info]
      options = [level: :warn]
      # must return two okays or the backend will terminate
      {:ok, :ok, ^options} = PLogger.handle_call({:configure, options}, state)
    end
  end

  describe "handle_event/2" do
    test ":warn event increments counter" do
      metadata = []
      message = "danger will robinson!"
      state = [level: :debug]

      {:ok, _} = PLogger.handle_event({:warn, self(), {Logger, message, @timestamp, metadata}}, state)

      assert 1 == Counter.value(name: :ex_logger, labels: [@hostname, :warn])
    end

    test ":error event does not interfere with :warn counter" do
      metadata = []
      message = "error!"
      state = [level: :debug]

      {:ok, _} = PLogger.handle_event({:error, self(), {Logger, message, @timestamp, metadata}}, state)

      assert :undefined == Counter.value(name: :ex_logger, labels: [@hostname, :warn])
    end

    test ":error event increments :error counter" do
      metadata = []
      message = "error!"
      state = [level: :debug]

      {:ok, _} = PLogger.handle_event({:error, self(), {Logger, message, @timestamp, metadata}}, state)
      {:ok, _} = PLogger.handle_event({:error, self(), {Logger, message, @timestamp, metadata}}, state)

      assert 2 == Counter.value(name: :ex_logger, labels: [@hostname, :error])
    end

    test ":info increments :info counter" do
      metadata = []
      message = "info!"
      state = [level: :info]

      0..2
      |> Enum.each(fn _ ->
        {:ok, _} = PLogger.handle_event({:info, self(), {Logger, message, @timestamp, metadata}}, state)
      end)

      assert 3 == Counter.value(name: :ex_logger, labels: [@hostname, :info])
    end

    test ":debug increments :debug counter" do
      metadata = []
      message = "debug"
      state = [level: :debug]

      {:ok, _} = PLogger.handle_event({:debug, self(), {Logger, message, @timestamp, metadata}}, state)

      assert 1 == Counter.value(name: :ex_logger, labels: [@hostname, :debug])
    end

    test "when level is :error, :warn does not increment" do
      metadata = []
      message = "danger will robinson!"
      state = [level: :error]

      {:ok, _} = PLogger.handle_event({:error, self(), {Logger, message, @timestamp, metadata}}, state)

      assert :undefined == Counter.value(name: :ex_logger, labels: [@hostname, :warn])
    end

    test "when level is :warn, :info does not increment" do
      metadata = []
      message = "info"
      state = [level: :warn]

      {:ok, _} = PLogger.handle_event({:info, self(), {Logger, message, @timestamp, metadata}}, state)

      assert :undefined == Counter.value(name: :ex_logger, labels: [@hostname, :info])
    end

    test "when level is :info, :debug does not increment" do
      metadata = []
      message = "debug"
      state = [level: :info]

      {:ok, _} = PLogger.handle_event({:debug, self(), {Logger, message, @timestamp, metadata}}, state)

      assert :undefined == Counter.value(name: :ex_logger, labels: [@hostname, :debug])
    end

    test "handles :flush" do
      # We don't need to do anything on the flush event,
      # because the user is responsible for publishing the metrics.
      state = []
      PLogger.handle_event(:flush, state)
    end
  end
end
