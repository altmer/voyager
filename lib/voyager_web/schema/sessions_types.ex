defmodule VoyagerWeb.Schema.SessionsTypes do
  @moduledoc """
  Graphql definitions for sessions and logins
  """

  use Absinthe.Schema.Notation

  alias VoyagerWeb.Resolvers.Sessions

  object :session do
    field(:token, :string)
    field(:current_user, :user)
  end

  object :session_destroy do
    field(:successful, :boolean)
  end

  object :sessions_queries do
    field :current_user, type: :user, description: "returns currently signed in user" do
      resolve(&Sessions.current_user/3)
    end
  end

  object :sessions_mutations do
    field :login, type: :session, description: "authentication attempt" do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Sessions.login/3)
    end

    field :logout, type: :session_destroy, description: "session invalidation" do
      resolve(&Sessions.logout/3)
    end
  end
end
