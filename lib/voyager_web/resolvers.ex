defmodule VoyagerWeb.Resolvers do
  @moduledoc """
  Common functions for graphql resolvers
  """

  def single_query_result(nil),
    do: {:error, :not_found}
  def single_query_result(result),
    do: {:ok, result}

  def mutation_result({:ok, result}),
    do: {:ok, result}
  def mutation_result({:error, %Ecto.Changeset{} = changeset}),
    do: {:ok, changeset}
end