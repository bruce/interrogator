defmodule Interrogator.Catalogue.Source do
  @enforce_keys [:id, :name, :filename, :commit]
  defstruct [:id, :name, :filename, :commit, book_ids: []]
end
