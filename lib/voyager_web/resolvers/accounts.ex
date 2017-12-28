defmodule VoyagerWeb.Resolvers.Accounts do
  @moduledoc """
  Graphql resolvers for accounts context
  """
  alias Voyager.Accounts.Users

  def find_user(_parent, %{id: id}, _resolution),
    do: {:ok, Users.get!(id)}
end
