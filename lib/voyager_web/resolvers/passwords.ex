defmodule VoyagerWeb.Resolvers.Passwords do
  @moduledoc """
  Graphql resolvers for passwords context
  """
  alias Voyager.Accounts.Passwords, as: VoyagerPasswords

  def forgot_password(_parent, %{email: email}, _resolution) do
    VoyagerPasswords.send_reset_password_email(email)
    {:ok, %{successful: true}}
  end
end
