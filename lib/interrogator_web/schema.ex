defmodule InterrogatorWeb.Schema do
  use Absinthe.Schema

  import_types __MODULE__.Catalogue.Types

  query do
    import_fields :catalogue_query
  end

end
