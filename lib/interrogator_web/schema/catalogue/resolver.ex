defmodule InterrogatorWeb.Schema.Catalogue.Resolver do

  alias Interrogator.Catalogue

  def units(_, %{filter: nil}, _) do
    {:ok, Catalogue.list(Catalogue.Unit)}
  end
  def units(_, %{filter: filter}, _) do
    {:ok, Catalogue.filter(Catalogue.Unit, &all_filters_pass?(filter, &1))}
  end
  def units(_, _, _) do
    {:ok, Catalogue.list(Catalogue.Unit)}
  end

  defp all_filters_pass?(filter, item) do
    Enum.all?(filter, &do_filter(&1, item))
  end

  defp do_filter({:name, pattern}, item) do
    String.contains?(String.downcase(item.name), String.downcase(pattern))
  end
  defp do_filter({filter_type, _}, _) do
    raise "Unknown filter type: #{filter_type}"
  end

end
