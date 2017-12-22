use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :voyager, VoyagerWeb.Endpoint,
  http: [port: 4000],
  secret_key_base: "svWE1TQ9lYke32lLUdE5jnV+EqI7nObwZ/rFYLH+s6BFRKU/prg559ADuLaohNx9",
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :voyager, VoyagerWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/voyager_web/views/.*(ex)$},
      ~r{lib/voyager_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :voyager, Voyager.Repo,
  database: "voyager_dev",
  pool_size: 10
