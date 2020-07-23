defmodule VoyagerWeb.Router do
  use VoyagerWeb, :router
  use Plug.ErrorHandler

  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :admins_only do
    plug(:basic_auth,
      username: "admin",
      password: Application.fetch_env!(:voyager, :admin_password)
    )
  end

  pipeline :api do
    plug(:accepts, ["json"])

    plug(
      Guardian.Plug.Pipeline,
      module: Voyager.Guardian,
      error_handler: VoyagerWeb.AuthErrorHandler
    )

    plug(Guardian.Plug.VerifyHeader, realm: :none)
    plug(Guardian.Plug.LoadResource, allow_blank: true)
    plug(VoyagerWeb.Plugs.Locale, "en")
    plug(VoyagerWeb.Plugs.Context)
  end

  scope "/" do
    pipe_through(:api)

    get("/", VoyagerWeb.RootController, :index)
    put("/upload_avatar", VoyagerWeb.UserController, :upload_avatar)
    put("/trips/upload_cover", VoyagerWeb.TripController, :upload_cover)

    forward(
      "/api",
      Absinthe.Plug,
      schema: VoyagerWeb.Schema,
      analyze_complexity: true,
      max_complexity: 200
    )
  end

  scope "/admin" do
    pipe_through([:browser, :admins_only])
    live_dashboard("/dashboard", metrics: VoyagerWeb.Telemetry)
  end
end
