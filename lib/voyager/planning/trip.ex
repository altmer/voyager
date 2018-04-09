defmodule Voyager.Planning.Trip do
  @moduledoc """
  Schema for trips table
  """
  use Ecto.Schema
  use Arc.Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias __MODULE__
  alias Voyager.Accounts.User
  alias Voyager.Planning.Cover

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @statuses ["0_draft", "1_planned", "2_finished"]
  @finished "2_finished"

  schema "trips" do
    field(:name, :string)
    field(:short_description, :string)
    field(:duration, :integer)
    field(:start_date, :date)
    field(:currency, :string)
    field(:status, :string)
    field(:private, :boolean)

    field(:cover, Cover.Type)
    field(:crop_x, :string, virtual: true)
    field(:crop_y, :string, virtual: true)
    field(:crop_width, :string, virtual: true)
    field(:crop_height, :string, virtual: true)

    field(:people_count_for_budget, :integer)
    field(:report, :string)

    field(:archived, :boolean)

    belongs_to(:author, User)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :short_description,
      :start_date,
      :duration,
      :currency,
      :status,
      :private,
      :people_count_for_budget,
      :report,
      :archived,
      :author_id
    ])
    |> validate_required([:name, :duration, :currency, :status, :author_id])
    |> validate_inclusion(:duration, 1..30)
    |> validate_inclusion(:status, @statuses)
    |> validate_start_date()
  end

  def validate_start_date(%Ecto.Changeset{changes: %{status: @finished}} = changeset),
    do: changeset |> validate_required(:start_date)

  def validate_start_date(changeset), do: changeset

  def upload_cover(struct, params \\ %{}) do
    struct
    |> cast(params, [:crop_x, :crop_y, :crop_width, :crop_height])
    |> cast_attachments(params, [:cover])
  end

  def query, do: from(t in Trip, where: t.archived == false)
  def by_id(id), do: from(t in query(), where: t.id == ^id)
end
