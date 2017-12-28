defmodule VoyagerWeb.Router do
  use VoyagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug VoyagerWeb.Plugs.Locale, "en"
  end

  scope "/" do
    pipe_through :api

    get "/", VoyagerWeb.RootController, :index

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: VoyagerWeb.Schema
    end

    forward "/api", Absinthe.Plug,
      schema: VoyagerWeb.Schema,
      analyze_complexity: true,
      max_complexity: 200
  end
end
