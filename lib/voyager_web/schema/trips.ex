defmodule VoyagerWeb.Schema.Trips do
  @moduledoc """
  GraphQL objects for trips and plans
  """
  use Absinthe.Schema.Notation

  import Kronky.Payload
  import_types(Kronky.ValidationMessageTypes)
  import_types(Absinthe.Type.Custom)

  alias Voyager.Planning.Cover
  alias VoyagerWeb.Resolvers.Trips

  object :trip do
    field(:id, :id)

    field(:name, :string)
    field(:short_description, :string)

    field(:duration, :integer)
    field(:start_date, :date)

    field(:end_date, :date) do
      # TODO: calculate end date here
    end

    field(:currency, :string)
    field(:status, :string)
    field(:private, :boolean)
    field(:people_count_for_budget, :integer)
    field(:report, :string)

    field(:author, :user) do
      # TODO: Use dataloader to load users
    end

    field :cover_thumb, :string do
      resolve(fn trip, _, _ ->
        {:ok, Cover.url({trip.cover, user}, :thumb)}
      end)
    end
  end

  payload_object(:user_payload, :user)

  input_object :trip_input do
    arg(:name, non_null(:string))
    arg(:short_description, :string)
    arg(:start_date, :date)
    arg(:duration, non_null(:integer))
    arg(:currency, non_null(:string))
    arg(:status, non_null(:status))
    arg(:private, :boolean)
    arg(:people_count_for_budget, non_null(:integer))
  end

  object :trips_mutations do
    field :create_trip, type: :trip_payload, description: "Creates trip" do
      arg(:trip_input, non_null(:trip_input))
      resolve(&Trips.create/3)
    end

    field :update_trip, type: :trip_payload, description: "Updates trip" do
      arg(:trip_input, non_null(:trip_input))
      resolve(&Trips.update/3)
    end

    field :delete_trip, type: :something, description: "Deletes trip (marks as archived)" do
      arg(:trip_id, non_null(:string))
      resolve(&Trips.delete/3)
    end
  end
end
