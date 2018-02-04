use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :voyager, VoyagerWeb.Endpoint,
  http: [port: 4001],
  secret_key_base: "svWE1TQ9lYke32lLUdE5jnV+EqI7nObwZ/rFYLH+s6BFRKU/prg559ADuLaohNx9_test",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :voyager, Voyager.Repo,
  database: "voyager_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :arc, storage: Arc.Storage.Local

config :voyager, Voyager.Guardian,
  secret_key: "svWE1TQ9lYke32lLUdE5jnV+EqI7nObwZ/rFYLH+s6BFRKU/prg559ADuLaohNx9_test"

config :voyager, Voyager.Emails.Mailer, adapter: Bamboo.TestAdapter
