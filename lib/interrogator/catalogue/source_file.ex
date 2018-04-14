defmodule Interrogator.Catalogue.SourceFile do
  import SweetXml

  def read!(filename) do
    filename
    |> File.read!
    |> do_read
  end

  def list do
    Path.join(:code.priv_dir(:interrogator), "bsdata/*.cat")
    |> Path.wildcard
  end

  defp do_read(data) do
    SweetXml.stream_tags(data, :selectionEntry)
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
