defmodule VoyagerWeb.Schema.AccountTypes do
  @moduledoc """
  GraphQL objects for user accounts
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :locale, :string
    field :currency, :string

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
