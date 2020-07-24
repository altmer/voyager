defmodule VoyagerWeb.Schema do
  @moduledoc """
  Main GraphQL schema
  """
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(VoyagerWeb.Schema.Users)
  import_types(VoyagerWeb.Schema.Sessions)
  import_types(VoyagerWeb.Schema.Passwords)
  import_types(VoyagerWeb.Schema.Trips)

  # these objects are copied from kronky
  object :validation_option do
    field(:key, non_null(:string))
    field(:value, non_null(:string))
  end

  object :validation_message do
    field(:field, :string)
    field(:message, :string)
    field(:code, non_null(:string))
    field(:template, :string)
    field(:options, list_of(:validation_option))
  end

  query do
    import_fields(:users_queries)
    import_fields(:sessions_queries)
  end

  mutation do
    import_fields(:users_mutations)
    import_fields(:sessions_mutations)
    import_fields(:passwords_mutations)
    import_fields(:trips_mutations)
  end
end
