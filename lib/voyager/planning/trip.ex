defmodule Voyager.Planning.Trip do
  @moduledoc """
  Schema for trips table
  """
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset

  alias Voyager.Accounts.User
  alias Voyager.Planning.Cover

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "trips" do
    field(:name, :string)
    field(:short_description, :string)
    field(:duration, :integer)
    field(:start_date, :date)
    field(:currency, :string)
    field(:status, :string)
    field(:private, :boolean)

    field(:cover, Cover.Type)
    field(:people_count_for_budget, :integer)
    field(:report, :string)

    field(:archived, :boolean)

    belongs_to(:author, User)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
