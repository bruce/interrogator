defmodule Interrogator.Util.EtsStore do
  use GenServer

  def child_spec(name) do
    default = %{
      id: name,
      start: {__MODULE__, :start_link, [name]}
    }

    Supervisor.child_spec(default, [])
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, [])
  end

  def init([name]) do
    ets = :ets.new(name, [:named_table, :public, write_concurrency: true, read_concurrency: true])
    {:ok, ets}
  end
end
