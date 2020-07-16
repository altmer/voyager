import Config

config :voyager, Voyager.Guardian, secret_key: System.fetch_env!("SECRET_KEY_BASE")

config :ex_aws,
  access_key_id: System.fetch_env!("AWS_S3_KEY"),
  secret_access_key: System.fetch_env!("AWS_S3_SECRET")

config :arc,
  bucket: System.fetch_env!("AWS_S3_BUCKET")

config :voyager, VoyagerWeb.Endpoint,
  http: [port: System.fetch_env!("PORT")],
  url: [host: System.fetch_env!("HOST"), port: 80],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :sentry, dsn: System.fetch_env!("SENTRY_DSN")

config :voyager, frontend_url: System.fetch_env!("FRONTEND_URL")

config :voyager, Voyager.Repo,
  username: System.fetch_env!("POSTGRES_USER"),
  password: System.fetch_env!("POSTGRES_PASSWORD"),
  hostname: System.fetch_env!("POSTGRES_HOST")

config :voyager, Voyager.Emails.Mailer,
  api_key: System.fetch_env!("MAILGUN_API_KEY"),
  domain: System.fetch_env!("MAILGUN_DOMAIN")
