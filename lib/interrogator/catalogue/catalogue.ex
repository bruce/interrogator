defmodule Interrogator.Catalogue do

  def insert(%table{} = row) do
    insert(table, row)
  end

  def insert(table, row) do
    attrs = Map.from_struct(row)
    :ets.insert(table, {attrs.id, attrs})
  end

  def get(table, id) do
    case :ets.lookup(table, id) do
      [{_, attrs}] -> struct(table, attrs)
      _ -> nil
    end
  end

  def list(table) do
    table
    |> :ets.tab2list()
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&struct(table, &1))
  end

  def find(table, fun) do
    list(table)
    |> Enum.find(fun)
  end

  def filter(table, fun) do
    list(table)
    |> Enum.filter(fun)
  end

end
