defmodule Voyager.Guardian do
  @moduledoc """
  Guardian module contains authentication rules.
  """
  use Guardian, otp_app: :voyager

  alias Voyager.Repo
  alias Voyager.Accounts.{AuthToken, User}

  def subject_for_token(%User{} = user, _claims), do: {:ok, user.id()}
  def subject_for_token(_, _), do: {:error, :unknown_resource_type}

  def resource_from_claims({%{"sub" => id}, _}), do: {:ok, Repo.get(User, id)}
  def resource_from_claims(_claims), do: {:error, :wrong_claims}

  def after_encode_and_sign(resource, claims, token, _) do
    jti = Map.get(claims, "jti")
    aud = Map.get(claims, "aud")
    exp = Map.get(claims, "exp")

    Repo.insert!(%AuthToken{
      user_id: resource.id,
      jwt: token,
      jti: jti,
      aud: aud,
      exp: exp
    })

    {:ok, {claims, token}}
  end

  def on_revoke(claims, jwt, _) do
    jti = Map.get(claims, "jti")
    aud = Map.get(claims, "aud")
    token = Repo.get_by!(AuthToken, %{jti: jti, aud: aud})
    Repo.delete!(token)
    {:ok, {claims, jwt}}
  end

  def on_verify(claims, jwt, _) do
    jti = Map.get(claims, "jti")
    aud = Map.get(claims, "aud")

    case Repo.get_by(AuthToken, %{jti: jti, aud: aud}) do
      nil -> {:error, :token_not_found}
      _ -> {:ok, {claims, jwt}}
    end
  end
end
