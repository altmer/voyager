defmodule Voyager.Repo.Migrations.CreateAuthTokens do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:auth_tokens, primary_key: false) do
      add(:id, :binary_id, primary_key: true)

      add(:jwt, :text, null: false)
      add(:jti, :string, null: false)
      add(:aud, :string, null: false)
      add(:exp, :integer, null: false)

      add(
        :user_id,
        references(
          :users,
          type: :binary_id,
          on_delete: :nothing
        )
      )

      timestamps()
    end

    create(index(:auth_tokens, [:user_id]))
  end
end
