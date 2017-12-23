defmodule VoyagerWeb.Router do
  use VoyagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VoyagerWeb do
    pipe_through :api

    get "/", RootController, :index
  end
end
