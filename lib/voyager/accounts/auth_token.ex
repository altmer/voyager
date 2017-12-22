defmodule Voyager.Accounts.AuthToken do
  @moduledoc """
  Schema for auth_tokens table.
  It is used for tracking current authorizations.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Voyager.Accounts.AuthToken

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}

  schema "auth_tokens" do
    field :aud, :string
    field :exp, :integer
    field :jti, :string
    field :jwt, :string

    belongs_to :user, Voyager.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:jwt, :jti, :aud, :exp])
    |> validate_required([:jwt, :jti, :aud, :exp])
  end
end
