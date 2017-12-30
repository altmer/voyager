defmodule VoyagerWeb.Resolvers.Sessions do
  @moduledoc """
  Graphql resolvers for sessions context
  """
  alias Voyager.Guardian
  alias Voyager.Accounts.Sessions, as: VoyagerSessions
  alias VoyagerWeb.Resolvers

  def login(_parent, args, _resolution),
    do: args |> VoyagerSessions.authenticate() |> authentication_result()

  def logout(_parent, _args, %{context: %{token: token}}) do
    Guardian.revoke(token)
    {:ok, %{successful: true}}
  end
  def logout(_, _, _),
    do: Resolvers.not_authorized()

  def current_user(_parent, _args, %{context: %{current_user: user}}),
    do: {:ok, user}
  def current_user(_, _, _),
    do: Resolvers.not_authorized()

  defp authentication_result({:ok, _, token}),
    do: {:ok, %{token: token}}
  defp authentication_result({:error, _} = error_tuple),
    do: error_tuple
end
