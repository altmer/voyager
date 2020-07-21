defmodule Voyager.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :voyager,
      version: "0.0.1",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      releases: releases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Voyager.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # web
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.1"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.11"},
      {:phoenix_live_view, "~> 0.13"},
      {:phoenix_live_dashboard, "~> 0.2"},

      # telemetry
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},

      # DB
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.15.0"},

      # json
      {:jason, "~> 1.2"},

      # money
      {:ex_money, "~> 5.2"},

      # file upload
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.0"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.6"},
      {:sweet_xml, "~> 0.6"},

      # authentication
      {:guardian, "~> 2.1"},
      {:comeonin, "~> 5.3"},
      {:bcrypt_elixir, "~> 2.2"},

      # emails
      {:bamboo, "~> 1.5"},

      # graphql
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:kronky, "~> 0.5.0"},

      # utils
      {:secure_random, "~> 0.5"},
      {:cors_plug, "~> 2.0"},

      # error reporting
      {:sentry, "~> 6.1"},

      # dev/test
      {:bamboo_smtp, "~> 2.1", only: :dev},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:faker, "~> 0.9", only: :test},
      {:ex_machina, "~> 2.1", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp releases() do
    [
      voyager: [
        include_executables_for: [:unix]
      ]
    ]
  end
end
