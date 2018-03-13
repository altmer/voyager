defmodule Voyager.Repo.Migrations.CreateTrips do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:trips, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:short_description, :string)

      add(:start_date, :date)
      add(:length, :integer, null: false, default: 1)

      add(:people_count_for_budget, :integer, null: false, default: 1)

      add(:report, :text)

      add(:private, :boolean, default: false)
      add(:archived, :boolean, default: false)

      timestamps()
    end
  end
end
