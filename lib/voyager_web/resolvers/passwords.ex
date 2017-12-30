defmodule VoyagerWeb.Resolvers.Passwords do
  @moduledoc """
  Graphql resolvers for passwords context
  """
  alias Voyager.Accounts.Passwords, as: VoyagerPasswords
  alias VoyagerWeb.Resolvers

  def forgot_password(_parent, %{email: email}, _resolution) do
    VoyagerPasswords.send_reset_password_email(email)
    {:ok, %{successful: true}}
  end

  def reset_password(_parent, %{password_reset_token: token} = args, _resolution) do
    token
    |> VoyagerPasswords.reset_password(args)
    |> Resolvers.mutation_result()
  end
end
