defmodule VoyagerWeb.Resolvers do
  @moduledoc """
  Common functions for graphql resolvers
  """

  def find_result(nil),
    do: {:error, :not_found}
  def find_result(result),
    do: {:ok, result}
end