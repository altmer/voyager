defmodule Voyager.Accounts.User do
  @moduledoc """
  Schema for users table
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Voyager.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :avatar, :string
    field :currency, :string
    field :email, :string
    field :encrypted_password, :string
    field :home_town_id, :string
    field :locale, :string
    field :name, :string
    field :reset_password_jti, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [
          :name, :email, :encrypted_password, :avatar, :locale,
          :reset_password_jti, :currency, :home_town_id
        ])
    |> validate_required([
          :name, :email, :encrypted_password, :avatar, :locale,
          :reset_password_jti, :currency, :home_town_id
        ])
  end
end
