defmodule VoyagerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import VoyagerWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint VoyagerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Voyager.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Voyager.Repo, {:shared, self()})
    end
    conn = Phoenix.ConnTest.build_conn()
    cond do
      tags[:login] ->
        user = Voyager.Factory.insert(:user)
        signed_conn = conn |> Plug.Conn.put_private(:absinthe, %{context: %{current_user: user}})
        {:ok, conn: signed_conn, logged_user: user}
      true ->
        {:ok, conn: conn}
    end
  end
end
