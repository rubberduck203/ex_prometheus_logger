defmodule Example do
  @moduledoc """
  Example of using the Pushgateway to publish your metrics
  """

  @doc """

  ## Examples

      iex> require Logger
      Logger
      iex> Logger.warn("Danger Will Robinson!")
      :ok
      iex> Example.push()
      :ok

  """
  def push do
    Prometheus.Push.push(%{
      job: "example_job",
      grouping_key: []
    })
  end
end
