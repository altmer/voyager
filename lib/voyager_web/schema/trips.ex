defmodule VoyagerWeb.Schema.Trips do
  @moduledoc """
  GraphQL objects for trips and plans
  """
  use Absinthe.Schema.Notation

  import Kronky.Payload

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
        {:ok, Cover.url({trip.cover, trip}, :thumb)}
      end)
    end
  end

  payload_object(:trip_payload, :trip)

  input_object :trip_input do
    field(:name, :string)
    field(:short_description, :string)
    field(:dates_unknown, :boolean)
    field(:duration, :integer)
    field(:start_date, :datetime)
    field(:end_date, :datetime)
    field(:currency, :string)
    field(:status, :string)
    field(:private, :boolean)
    field(:people_count_for_budget, :integer)
  end

  object :trips_mutations do
    field :create_trip, type: :trip_payload, description: "Creates trip" do
      arg(:input, non_null(:trip_input))
      resolve(&Trips.create/3)
    end

    field :update_trip, type: :trip_payload, description: "Updates trip" do
      arg(:id, non_null(:string))
      arg(:input, non_null(:trip_input))
      resolve(&Trips.update/3)
    end

    field :delete_trip,
      type: :trip_payload,
      description: "Deletes trip (marks as archived)" do
      arg(:id, non_null(:string))
      resolve(&Trips.delete/3)
    end
  end
end
