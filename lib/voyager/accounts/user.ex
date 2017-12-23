defmodule Voyager.Accounts.User do
  @moduledoc """
  Schema for users table
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Voyager.Accounts.{Avatar, User}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}

  schema "users" do
    field :email, :string
    field :name, :string

    field :avatar, Avatar.Type
    field :crop_x, :string, virtual: true
    field :crop_y, :string, virtual: true
    field :crop_width, :string, virtual: true
    field :crop_height, :string, virtual: true

    field :currency, :string

    field :encrypted_password, :string
    field :reset_password_jti, :string
    field :password, :string, virtual: true
    field :old_password, :string, virtual: true

    field :home_town_id, :string
    field :locale, :string

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
