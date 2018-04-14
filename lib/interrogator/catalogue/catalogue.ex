defmodule Interrogator.Catalogue do

  def insert(table, row) do
    :ets.insert(table, row)
  end

  def get(table, id) do
    case :ets.lookup(table, id) do
      [{_, attrs}] -> attrs
      _ -> nil
    end
  end

  def list(table) do
    table
    |> :ets.tab2list()
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
  end

end
