defmodule VoyagerWeb.Resolvers.Accounts do
  @moduledoc """
  Graphql resolvers for accounts context
  """
  alias Voyager.Accounts.Users
  alias VoyagerWeb.Resolvers

  def find_user(_parent, %{id: id}, _resolution),
    do: id |> Users.get() |> Resolvers.single_query_result()

  def register(_parent, args, _resolution),
    do: args |> Users.add() |> Resolvers.mutation_result()
end
