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

  def update_profile(_parent, args, %{context: %{current_user: current_user}}),
    do: current_user
        |> Users.update_profile(args)
        |> Resolvers.mutation_result()
  def update_profile(_parent, _args, _resolution),
    do: Resolvers.not_authorized()

  def update_locale(_parent, args, %{context: %{current_user: current_user}}),
    do: current_user
        |> Users.update_locale(args)
        |> Resolvers.mutation_result()
  def update_locale(_parent, _args, _resolution),
    do: Resolvers.not_authorized()
end
