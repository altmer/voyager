defmodule VoyagerWeb.Router do
  use VoyagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline, module: Voyager.Guardian,
                                 error_handler: VoyagerWeb.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: :none
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug VoyagerWeb.Plugs.Locale, "en"
    plug VoyagerWeb.Plugs.Context
  end

  scope "/" do
    pipe_through :api

    get "/", VoyagerWeb.RootController, :index
    put "/upload_avatar", VoyagerWeb.UserController, :upload_avatar

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
