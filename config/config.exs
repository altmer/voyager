# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :voyager,
  ecto_repos: [Voyager.Repo],
  frontend_url: "http://localhost:3000",
  admin_password: "test1234"

# Configures the endpoint
config :voyager, VoyagerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: VoyagerWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Voyager.PubSub,
  live_view: [signing_salt: "UJlE+bsFWXNHHh/gtjEjqBfdlz68DnAx"]

config :voyager, Voyager.Repo,
  hostname: "localhost",
  port: "5432",
  username: "postgres",
  password: ""

config :arc,
  storage: Arc.Storage.S3,
  virtual_host: true

config :ex_aws,
  region: "eu-central-1",
  host: "s3.eu-central-1.amazonaws.com",
  s3: [
    scheme: "https://",
    host: "s3.eu-central-1.amazonaws.com",
    region: "eu-central-1"
  ]

config :voyager, Voyager.Guardian,
  issuer: "Voyager",
  verify_issuer: true,
  token_module: Guardian.Token.Jwt

config :voyager, Voyager.Emails.Mailer,
  adapter: Bamboo.MailgunAdapter,
  from: "noreply@travel.hmstr.rocks"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sentry,
  filter: Voyager.SentryEventFilter,
  environment_name: :dev,
  included_environments: [:prod]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
