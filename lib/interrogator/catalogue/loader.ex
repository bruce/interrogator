defmodule Interrogator.Catalogue.Loader do
  use GenServer
  require Logger

  alias Interrogator.Catalogue.Loader.SourceFile

  ## Handlers

  def handle(_, _) do
    :ok
  end

  ## Boilerplate

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    send(self(), :rebuild)
    {:ok, []}
  end

  ## Rebuild ETS tables

  def handle_info(:rebuild, state) do
    for file <- SourceFile.list() do
      catalogue_name = Path.basename(file, ".cat")
      data = SourceFile.read!(file)

      # Build Source entry
      static_attrs = %{filename: file, commit: "foo"}
      parsed_attrs =
        Map.take(data, ~w(id name)a)
        |> Enum.filter(fn {_, v} -> v != "" end)
        |> Map.new
      source_attrs = Map.merge(static_attrs, parsed_attrs)
      source_attrs =
        if data.books && data.books != "" do
          # Build Books
          book_ids = String.split(data.books, ",") |> Enum.map(&String.trim/1)
          for book_id <- book_ids do
            Interrogator.Catalogue.insert(Interrogator.Catalogue.Book.from_name(book_id))
          end
          Map.put(source_attrs, :book_ids, book_ids)
        else
          source_attrs
        end
      source = struct(Interrogator.Catalogue.Source, source_attrs)
      Interrogator.Catalogue.insert(source)

      # Build Unit Entries
      for {name, offset} <- Enum.with_index(data.units) do
        id = "#{catalogue_name}-#{offset}"
        Interrogator.Catalogue.insert(%Interrogator.Catalogue.Unit{id: id, name: name, source_id: source.id, source_line: 12})
      end

      Logger.warn "Loaded #{length data.units} units from #{source.name}"
    end
    {:noreply, state}
  end

end
