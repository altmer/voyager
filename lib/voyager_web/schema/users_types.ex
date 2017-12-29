defmodule VoyagerWeb.Schema.UsersTypes do
  @moduledoc """
  GraphQL objects for user accounts
  """
  use Absinthe.Schema.Notation

  import Kronky.Payload
  import_types Kronky.ValidationMessageTypes

  alias Voyager.Accounts.Avatar
  alias VoyagerWeb.Resolvers.Users

  object :user do
    field :id, :id
    field :name, :string
    field :locale, :string
    field :currency, :string
    field :home_town_id, :string

    field :initials, :string do
      resolve fn user, _, _ ->
        {:ok, initials(user)}
      end
    end

    field :color, :string do
      resolve fn user, _, _ ->
        {:ok, color(user)}
      end
    end

    field :avatar_thumb, :string do
      resolve fn user, _, _ ->
        {:ok, Avatar.url({user.avatar, user}, :thumb)}
      end
    end
  end

  object :accounts_queries do
    field :user, type: :user, description: "Get a user of the app (for user profile page f.ex.)" do
      arg :id, non_null(:id)
      resolve &Users.find_user/3
    end
  end

  payload_object(:user_payload, :user)

  object :accounts_mutations do
    field :register, type: :user_payload, description: "Register new user" do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)
      arg :locale, :string

      resolve &Users.register/3
    end

    field :update_profile, type: :user_payload, description: "Updates current user's profile" do
      arg :name, :string
      arg :home_town_id, :string
      arg :currency, :string

      resolve &Users.update_profile/3
    end

    field :update_locale, type: :user_payload, description: "Updates current user's locale" do
      arg :locale, non_null(:string)

      resolve &Users.update_locale/3
    end

    field :update_password, type: :user_payload, description: "Changes user's password" do
      arg :old_password, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)

      resolve &Users.update_password/3
    end
  end

  defp initials(user) do
    user.name
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(&(String.first(&1)))
    |> Enum.take(2)
    |> Enum.join
    |> String.upcase
  end

  defp color(user) do
    number = user.id
             |> to_charlist
             |> Enum.reduce(&+/2)
             |> rem(4)
    "user-color-#{number}"
  end
end
