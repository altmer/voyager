defmodule Voyager.Accounts.Sessions do
  @moduledoc """
    Functions to work with session
  """
  @auth_failed {:error, :auth_failed}

  alias Voyager.Accounts.User
  alias Voyager.Guardian
  alias Voyager.Repo

  def authenticate(%{email: nil}), do: @auth_failed
  def authenticate(%{email: ""}), do: @auth_failed

  def authenticate(%{email: email, password: password}) do
    with user <- Repo.get_by(User, email: String.downcase(email)),
         true <- verify_password(user, password) do
      gen_token(user)
    else
      _ -> @auth_failed
    end
  end

  def from_token(jwt) do
    with {:ok, claims} <- Guardian.decode_and_verify(jwt),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      {:ok, user, claims["jti"]}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def gen_token(nil), do: @auth_failed

  def gen_token(user) do
    {:ok, jwt, _} = Guardian.encode_and_sign(user, %{}, ttl: {1, :week})
    {:ok, user, jwt}
  end

  defp verify_password(nil, _), do: false

  defp verify_password(user, password),
    do: Bcrypt.verify_pass(password, user.encrypted_password)
end
