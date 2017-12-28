defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  import_types VoyagerWeb.Schema.AccountTypes

  query do
    import_fields :accounts_queries
  end

  mutation do
    import_fields :accounts_mutations
  end
end
