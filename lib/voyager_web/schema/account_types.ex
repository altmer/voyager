defmodule VoyagerWeb.Schema.AccountTypes do
  @moduledoc """
  GraphQL objects for user accounts
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :locale, :string
    field :currency, :string
  end
end
