defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  import_types VoyagerWeb.Schema.UsersTypes
  import_types VoyagerWeb.Schema.SessionsTypes

  query do
    import_fields :accounts_queries
  end

  mutation do
    import_fields :accounts_mutations
    import_fields :sessions_mutations
  end
end
