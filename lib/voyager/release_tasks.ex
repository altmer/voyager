defmodule Voyager.ReleaseTasks do
  @moduledoc """
  Deployment tasks to create and migrate the database.
  """

  @start_apps [:crypto, :ssl, :postgrex, :ecto]
  @app :voyager

  require Logger
  alias Voyager.Repo
  alias Ecto.Migrator

  def db_create do
    with_environment_loaded(fn ->
      config = [
        username: db_config(:username),
        password: db_config(:password),
        hostname: db_config(:hostname),
        database: db_config(:database)
      ]

      IO.puts("#{inspect(config)}")

      case Repo.__adapter__().storage_up(config) do
        :ok ->
          Logger.info("Database created")

        {:error, :already_up} ->
          Logger.info("Database already exists")

        {:error, reason} ->
          raise "Database creation failed (#{reason})"
      end
    end)
  end

  def db_migrate do
    with_environment_loaded(fn ->
      Logger.info("Running migrations")
      Migrator.run(Repo, migrations_path(), :up, all: true)
    end)
  end

  defp with_environment_loaded(fun) do
    IO.puts("Loading application..")

    case Application.load(@app) do
      :ok -> nil
      {:error, {:already_loaded, @app}} -> nil
      {:error, reason} -> raise "Error loading application #{reason}"
    end

    IO.puts("Starting dependencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    Logger.info("Starting repo..")
    Repo.start_link(pool_size: 1)

    fun.()

    :init.stop()
  end

  defp db_config, do: Application.get_env(@app, Repo)

  defp db_config(key) do
    case db_config() |> Keyword.fetch(key) do
      {:ok, val} -> val
      :error -> nil
    end
  end

  defp priv_dir, do: "#{:code.priv_dir(@app)}"
  defp migrations_path, do: Path.join([priv_dir(), "repo", "migrations"])
end
