defmodule Interrogator.Catalogue.Book do

  @enforce_keys [:id, :name, :type]
  defstruct [:id, :name, :type]

  def from_name(name) do
    name = String.trim(name)
    %__MODULE__{
      id: name,
      name: name,
      type: type_from_name(name),
    }
  end

  @patterns [
    index: "Index",
    codex: "Codex"
  ]
  def type_from_name(name) do
    Enum.find(@patterns, fn {_, pattern} -> String.contains?(name, pattern) end)
    |> case do
         {type, _} ->
           type
         _ ->
           :unknown
       end
  end

end
