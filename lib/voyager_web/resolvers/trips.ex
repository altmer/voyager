defmodule VoyagerWeb.Resolvers.Trips do
  @moduledoc """
  Graphql resolvers for accounts context
  """
  alias Voyager.Planning.Trips, as: VoyagerTrips
  alias VoyagerWeb.Resolvers

  def create(_parent, args, _resolution),
    do: args |> VoyagerUsers.add() |> Resolvers.mutation_result()

  def update(_parent, args, %{context: %{current_user: current_user}}),
    do:
      current_user
      |> VoyagerUsers.update_profile(args)
      |> Resolvers.mutation_result()

  def update(_parent, _args, _resolution), do: Resolvers.not_authorized()

  def delete(_parent, args, %{context: %{current_user: current_user}}),
    do:
      current_user
      |> VoyagerUsers.update_password(args)
      |> Resolvers.mutation_result()

  def delete(_parent, _args, _resolution), do: Resolvers.not_authorized()
end
