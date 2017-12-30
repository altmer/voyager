defmodule VoyagerWeb.Schema.PasswordsTypes do
  @moduledoc """
  GraphQL objects for passwords operations
  """
  use Absinthe.Schema.Notation

  alias VoyagerWeb.Resolvers.Passwords

  object :forgot_password do
    field :successful, :boolean
  end

  object :passwords_mutations do
    field :forgot_password,
          type: :forgot_password,
          description: "request to send forgot password link" do
      arg :email, non_null(:string)

      resolve &Passwords.forgot_password/3
    end
  end
end
