defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  alias VoyagerWeb.Resolvers.Accounts

  import_types VoyagerWeb.Schema.AccountTypes

  query do
    @desc "Get a user of the app"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &Accounts.find_user/3
    end
  end
end
