defmodule InterrogatorWeb.Schema.Catalogue.Types do
  use Absinthe.Schema.Notation

  alias InterrogatorWeb.Schema.Catalogue.Resolver

  object :catalogue_query do
    field :units, list_of(:unit) do
      arg :filter, :unit_filter
      resolve &Resolver.units/3
    end
    field :catalogues, list_of(:catalogue) do
      arg :filter, :catalogue_filter
      resolve &Resolver.catalogues/3
    end
  end

  # TODO
  object :catalogue do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :books, list_of(:catalogue_book), resolve: &Resolver.catalogue_books/3
    field :commit, non_null(:string) # Git SHA
    field :units, non_null(list_of(:unit)) do
      arg :filter, :unit_filter
      resolve &Resolver.catalogue_units/3
    end
  end

  object :catalogue_book do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :type, non_null(:catalogue_book_type)
  end

  # TODO
  object :catalogue_reference do
    field :catalogue, non_null(:catalogue)
    field :line, non_null(:integer)
  end

  enum :catalogue_book_type do
    value :index
    value :codex
    value :unknown
  end

  object :unit do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :reference, non_null(:catalogue_reference), resolve: &Resolver.unit_reference/3
  end

  input_object :unit_filter do
    field :name, :string
  end

  input_object :catalogue_filter do
    field :name, :string
    field :book, :string
    field :book_type, :catalogue_book_type
  end

end
