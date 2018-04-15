defmodule InterrogatorWeb.Schema.Catalogue.Resolver do

  alias Interrogator.Catalogue

  def catalogues(_, %{filter: nil}, _) do
    {:ok, Catalogue.list(Catalogue.Source)}
  end
  def catalogues(_, %{filter: filter}, _) do
    {:ok, Catalogue.filter(Catalogue.Source, &all_filters_pass?(filter, &1))}
  end
  def catalogues(_, _, _) do
    {:ok, Catalogue.list(Catalogue.Source)}
  end

  def catalogue_books(catalogue, _, _) do
    books = Enum.map(catalogue.book_ids, &Catalogue.get(Catalogue.Book, &1))
    {:ok, books}
  end

  def units(_, %{filter: nil}, _) do
    {:ok, Catalogue.list(Catalogue.Unit)}
  end
  def units(_, %{filter: filter}, _) do
    {:ok, Catalogue.filter(Catalogue.Unit, &all_filters_pass?(filter, &1))}
  end
  def units(_, _, _) do
    {:ok, Catalogue.list(Catalogue.Unit)}
  end

  def catalogue_units(catalogue, %{filter: nil}, _) do
    {:ok, Catalogue.filter(Catalogue.Unit, &(&1.source_id == catalogue.id))}
  end
  def catalogue_units(catalogue, %{filter: filter}, _) do
    list =
      Catalogue.filter(Catalogue.Unit, fn unit ->
        unit.source_id == catalogue.id && all_filters_pass?(filter, unit)
      end)
    {:ok, list}
  end
  def catalogue_units(catalogue, _, _) do
    {:ok, Catalogue.filter(Catalogue.Unit, &(&1.source_id == catalogue.id))}
  end

  def unit_reference(unit, _, _) do
    catalogue = Catalogue.get(Catalogue.Source, unit.source_id)
    {:ok, %{line: unit.source_line, catalogue: catalogue}}
  end

  defp all_filters_pass?(filter, item) do
    Enum.all?(filter, &do_filter(&1, item))
  end

  defp do_filter({:name, pattern}, item) do
    filter_match(item, :name, pattern)
  end
  defp do_filter({:book, pattern}, item) do
    filter_match(item, :book, pattern)
  end
  defp do_filter({:book_type, book_type}, item) do
    Enum.any?(item.book_ids, fn name -> Catalogue.Book.type_from_name(name) == book_type end)
  end

  defp do_filter({filter_type, _}, _) do
    raise "Unknown filter type: #{filter_type}"
  end

  defp filter_match(item, field, pattern) do
    data = Map.get(item, field)
    if data do
      String.contains?(String.downcase(data), String.downcase(pattern))
    else
      false
    end
  end

end
