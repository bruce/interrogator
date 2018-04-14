defmodule Interrogator.Catalogue.Loader do
  use GenServer
  require Logger

  alias Interrogator.Catalogue.SourceFile

  ## Handlers

  def handle(_, _) do
    :ok
  end

  ## Boilerplate

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    send(self(), :rebuild)
    {:ok, []}
  end

  ## Rebuild ETS tables

  def handle_info(:rebuild, state) do
    for file <- SourceFile.list() do
      data = SourceFile.read!(file)
      Logger.warn "Loaded #{length data} units from #{Path.basename(file, ".cat")}"
    end
    {:noreply, state}
  end

end
