defmodule VoyagerWeb.Resolvers.Sessions do
  @moduledoc """
  Graphql resolvers for sessions context
  """
  alias Voyager.Accounts.Sessions

  def login(_parent, args, _resolution),
    do: args |> Sessions.authenticate() |> authentication_result()

  defp authentication_result({:ok, _, token}),
    do: {:ok, %{token: token}}
  defp authentication_result({:error, _} = error_tuple),
    do: error_tuple
end
