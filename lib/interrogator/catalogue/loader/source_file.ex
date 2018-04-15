defmodule Interrogator.Catalogue.Loader.SourceFile do
  import SweetXml

  @enforce_keys [:id, :name, :books]
  defstruct [:id, :name, :books, units: []]

  def read!(filename) do
    filename
    |> File.read!
    |> do_read
  end

  def list do
    Path.join(:code.priv_dir(:interrogator), "bsdata/*.cat")
    |> Path.wildcard
  end

  defp do_read(doc) do
    data =
      SweetXml.xpath(doc,
        ~x"/catalogue",
        [id: ~x"./@id"s,
         name: ~x"./@name"s,
         books: ~x"./@book"s
        ]
      )
    struct(__MODULE__, Map.merge(data, %{units: read_units(doc)}))
  end

  defp read_units(doc) do
    SweetXml.stream_tags(doc, :selectionEntry)
    |> Stream.filter(fn {_, tag} ->
      unit_tag?(tag) || model_tag?(tag)
    end)
    |> Stream.map(fn {_, tag} ->
      SweetXml.xpath(tag, ~x"./@name"s)
    end)
    |> Enum.to_list
  end

  defp unit_tag?(tag) do
    SweetXml.xpath(tag, ~x"./@type"s) == "unit" || SweetXml.xpath(tag, ~x"//profile[@profileTypeName='Unit']")
  end

  defp model_tag?(tag) do
    SweetXml.xpath(tag, ~x"./@type"s) == "model" || SweetXml.xpath(tag, ~x"//profile[@profileTypeName='Model']")
  end

end
