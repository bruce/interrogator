defmodule InterrogatorWeb.Router do
  use InterrogatorWeb, :router

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :graphql
    forward "/graphql", Absinthe.Plug,
      schema: InterrogatorWeb.Schema
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: InterrogatorWeb.Schema,
      interface: :playground,
      default_url: "http://localhost:4000/api/graphql"
  end

end
