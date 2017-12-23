defmodule VoyagerWeb.Router do
  use VoyagerWeb, :router

  forward "/api", Absinthe.Plug,
    schema: VoyagerWeb.Schema

  pipeline :json do
    plug :accepts, ["json"]
  end

  scope "/", VoyagerWeb do
    pipe_through :json

    get "/", RootController, :index
  end
end
