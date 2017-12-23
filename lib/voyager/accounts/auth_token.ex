defmodule Voyager.Accounts.AuthToken do
  @moduledoc """
  Schema for auth_tokens table.
  It is used for tracking current authorizations.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Voyager.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}

  schema "auth_tokens" do
    field :aud, :string
    field :exp, :integer
    field :jti, :string
    field :jwt, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:jwt, :jti, :aud, :exp, :user_id])
    |> validate_required([:jwt, :jti, :aud, :exp, :user_id])
  end
end
