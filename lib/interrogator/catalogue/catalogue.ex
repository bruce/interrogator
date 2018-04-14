defmodule Interrogator.Catalogue do

  @table __MODULE__.Units

  def insert(row) do
    :ets.insert(@table, row)
  end

  def get(id) do
    case :ets.lookup(@table, id) do
      [{_, attrs}] -> attrs
      _ -> nil
    end
  end

  def list do
    @table
    |> :ets.tab2list()
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
  end

  def find(fun) do
    list()
    |> Enum.find(fun)
  end

  def filter(fun) do
    list()
    |> Enum.filter(fun)
  end

end
