defmodule VoyagerWeb.Resolvers.Trips do
  @moduledoc """
  Graphql resolvers for accounts context
  """
  alias Voyager.Planning.Trips, as: VoyagerTrips
  alias VoyagerWeb.Resolvers

  def create(_parent, %{input: args}, %{context: %{current_user: current_user}}) do
    args
    |> VoyagerTrips.add(current_user)
    |> Resolvers.mutation_result()
  end

  def update(_parent, %{input: args, id: trip_id}, %{
        context: %{current_user: current_user}
      }) do
    with {:ok, trip} <- VoyagerTrips.get(trip_id),
         :ok <- Bodyguard.permit(VoyagerTrips, :update, current_user, trip) do
      trip
      |> VoyagerTrips.update(args)
      |> Resolvers.mutation_result()
    end
  end

  def delete(_parent, args, %{context: %{current_user: current_user}}),
    do:
      current_user
      |> VoyagerUsers.update_password(args)
      |> Resolvers.mutation_result()

  def delete(_parent, _args, _resolution), do: Resolvers.not_authorized()
end
