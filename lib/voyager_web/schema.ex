defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  import_types VoyagerWeb.Schema.UsersTypes
  import_types VoyagerWeb.Schema.SessionsTypes
  import_types VoyagerWeb.Schema.PasswordsTypes

  query do
    import_fields :users_queries
    import_fields :sessions_queries
  end

  mutation do
    import_fields :users_mutations
    import_fields :sessions_mutations
    import_fields :passwords_mutations
  end
end
