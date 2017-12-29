defmodule VoyagerWeb.Schema.SessionTypes do
  @moduledoc """
  Graphql definitions for sessions and logins
  """

  use Absinthe.Schema.Notation

  alias VoyagerWeb.Resolvers.Sessions

  object :session do
    field :token, :string
  end

  object :sessions_mutations do
    field :login, type: :session, description: "authentication attempt" do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Sessions.login/3
    end
  end
end
