defmodule Voyager.Application do
  @moduledoc """
  Main Voyager application
  """
  use Application

  alias Voyager.Accounts.AuthTokenSweeper
  alias VoyagerWeb.Endpoint

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      Voyager.Repo,
      # Start the endpoint when the application starts
      VoyagerWeb.Endpoint,
      # pubsub
      {Phoenix.PubSub, name: Voyager.PubSub},
      AuthTokenSweeper
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Voyager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
