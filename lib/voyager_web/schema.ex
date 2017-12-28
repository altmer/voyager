defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  alias VoyagerWeb.Resolvers.Accounts

  import_types VoyagerWeb.Schema.AccountTypes

  query do
    @desc "Get a user of the app (for user profile page f.ex.)"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &Accounts.find_user/3
    end
  end

  mutation do
    @desc "Register new user"
    field :register, type: :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)
      arg :locale, :string

      resolve &Accounts.register/3
    end
  end
end
