defmodule Voyager.Repo.Migrations.CreateTrips do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:trips, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(:name, :string, null: false)
      add(:short_description, :string)
      add(:start_date, :date)
      add(:duration, :integer, null: false, default: 1)
      add(:currency, :string, null: false)
      add(:status, :string, null: false)
      add(:private, :boolean, default: false)

      add(:cover, :string)
      add(:people_count_for_budget, :integer, null: false, default: 1)
      add(:report, :text)

      add(:archived, :boolean, default: false)

      add(
        :author_id,
        references(
          :users,
          type: :binary_id,
          on_delete: :nothing
        )
      )

      timestamps()
    end

    create(index(:trips, [:user_id]))
  end
end
