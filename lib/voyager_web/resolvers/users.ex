defmodule VoyagerWeb.Resolvers.Users do
  @moduledoc """
  Graphql resolvers for accounts context
  """
  alias Voyager.Accounts.Users, as: VoyagerUsers
  alias VoyagerWeb.Resolvers

  def find_user(_parent, %{id: id}, _resolution),
    do: id |> VoyagerUsers.get() |> Resolvers.single_query_result()

  def register(_parent, args, _resolution),
    do: args |> VoyagerUsers.add() |> Resolvers.mutation_result()

  def update_profile(_parent, args, %{context: %{current_user: current_user}}),
    do:
      current_user
      |> VoyagerUsers.update_profile(args)
      |> Resolvers.mutation_result()

  def update_profile(_parent, _args, _resolution), do: Resolvers.not_authorized()

  def update_password(_parent, args, %{context: %{current_user: current_user}}),
    do:
      current_user
      |> VoyagerUsers.update_password(args)
      |> Resolvers.mutation_result()

  def update_password(_parent, _args, _resolution), do: Resolvers.not_authorized()
end
