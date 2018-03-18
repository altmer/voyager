defmodule Voyager.Repo.Migrations.CreateUsers do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:email, :string, null: false)
      add(:encrypted_password, :string, null: false)
      add(:avatar, :string)
      add(:locale, :string, default: "en", null: false)
      add(:reset_password_jti, :string)
      add(:currency, :string)
      add(:home_town_id, :string)

      timestamps()
    end
  end
end
