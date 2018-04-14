defmodule InterrogatorWeb.Router do
  use InterrogatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", InterrogatorWeb do
    pipe_through :api
  end
end
