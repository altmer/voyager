# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :voyager, ecto_repos: [Voyager.Repo], frontend_url: "http://localhost:3000"

# Configures the endpoint
config :voyager, VoyagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "${SECRET_KEY_BASE}",
  render_errors: [view: VoyagerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Voyager.PubSub, adapter: Phoenix.PubSub.PG2]

config :voyager, Voyager.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "localhost",
  port: "5432",
  username: "postgres",
  password: ""

config :arc,
  storage: Arc.Storage.S3,
  bucket: "${AWS_S3_BUCKET}",
  virtual_host: true

config :ex_aws,
  access_key_id: "${AWS_S3_KEY}",
  secret_access_key: "${AWS_S3_SECRET}",
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
  secret_key: "${SECRET_KEY_BASE}",
  token_module: Guardian.Token.Jwt

config :voyager, Voyager.Emails.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "${MAILGUN_API_KEY}",
  domain: "${MAILGUN_DOMAIN}",
  from: "noreply@travel.hmstr.me"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "${GOOGLE_CLIENT_ID}",
  client_secret: "${GOOGLE_CLIENT_SECRET}"

config :sentry,
  filter: Voyager.SentryEventFilter,
  environment_name: :dev,
  included_environments: [:prod]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
