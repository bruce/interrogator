defmodule InterrogatorWeb.Schema.Catalogue.Types do
  use Absinthe.Schema.Notation

  alias InterrogatorWeb.Schema.Catalogue.Resolver

  object :catalogue_query do
    field :units, list_of(:unit) do
      arg :filter, :unit_filter
      resolve &Resolver.units/3
    end
  end

  # TODO
  object :catalogue do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :revision, non_null(:string) # Git SHA
  end

  # TODO
  object :catalogue_reference do
    field :catalogue, non_null(:catalogue)
    field :line, non_null(:integer)
  end

  object :unit do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  input_object :unit_filter do
    field :name, :string
  end

end
