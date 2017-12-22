defmodule Voyager.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :jwt, :text
      add :jti, :string
      add :aud, :string
      add :exp, :integer
      add :user_id, references(
        :users, type: :binary_id, on_delete: :nothing
      )

      timestamps()
    end

    create index(:auth_tokens, [:user_id])
  end
end
