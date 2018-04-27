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
  @duration_range 1..30

  schema "trips" do
    field(:name, :string)
    field(:short_description, :string)

    field(:dates_unknown, :boolean, virtual: true)
    field(:duration, :integer)
    field(:start_date, :date)
    field(:end_date, :date, virtual: true)

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

  def query, do: from(t in Trip, where: t.archived == false)
  def by_id(id), do: from(t in query(), where: t.id == ^id)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :short_description,
      :dates_unknown,
      :start_date,
      :end_date,
      :duration,
      :currency,
      :status,
      :private,
      :people_count_for_budget,
      :report,
      :author_id
    ])
    |> validate_required([
      :name,
      :currency,
      :status,
      :author_id,
      :dates_unknown
    ])
    |> validate_inclusion(:status, @statuses)
    |> process_dates()
  end

  def archive_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :archived
    ])
    |> validate_required(:archived)
  end

  defp process_dates(
         %Ecto.Changeset{valid?: true, changes: %{status: @finished}} = changeset
       ),
       do: process_known_dates(changeset)

  defp process_dates(
         %Ecto.Changeset{valid?: true, changes: %{dates_unknown: false}} = changeset
       ),
       do: process_known_dates(changeset)

  defp process_dates(
         %Ecto.Changeset{valid?: true, changes: %{dates_unknown: true}} = changeset
       ) do
    changeset
    |> validate_required(:duration)
    |> validate_inclusion(:duration, @duration_range)
    |> put_change(
      :start_date,
      nil
    )
  end

  defp process_dates(changeset), do: changeset

  defp process_known_dates(changeset) do
    changeset
    |> validate_required([:start_date, :end_date])
    |> validate_date_range()
    |> put_duration()
  end

  defp validate_date_range(
         %Ecto.Changeset{
           valid?: true,
           changes: %{start_date: start_date, end_date: end_date}
         } = changeset
       ) do
    if compute_duration(start_date, end_date) in @duration_range do
      changeset
    else
      add_error(changeset, :end_date, "trip duration invalid")
    end
  end

  defp validate_date_range(changeset), do: changeset

  defp put_duration(
         %Ecto.Changeset{
           valid?: true,
           changes: %{start_date: start_date, end_date: end_date}
         } = changeset
       ) do
    changeset
    |> put_change(
      :duration,
      compute_duration(start_date, end_date)
    )
  end

  defp put_duration(changeset), do: changeset

  defp compute_duration(start_date, end_date), do: Date.diff(end_date, start_date) + 1

  def upload_cover(struct, params \\ %{}) do
    struct
    |> cast(params, [:crop_x, :crop_y, :crop_width, :crop_height])
    |> cast_attachments(params, [:cover])
  end
end
