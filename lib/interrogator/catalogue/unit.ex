defmodule Interrogator.Catalogue.Unit do
  @enforce_keys [:id, :name, :source_id, :source_line]
  defstruct [:id, :name, :source_id, :source_line]
end
