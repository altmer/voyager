defmodule Voyager.Accounts.Users do
  @moduledoc """
    CRUD actions concerning users
  """
  alias Ecto.Multi
  alias Voyager.Repo
  alias Voyager.Accounts.User

  def get(id), do: Repo.get(User, id)
  def get!(id), do: Repo.get!(User, id)

  def get_by_email(nil), do: nil
  def get_by_email(email), do: Repo.get_by(User, email: email)

  def add(user_params) do
    %{locale: "en"} # default locale param
    |> Map.merge(user_params)
    |> create_user()
    |> transaction_result()
  end

  def update_profile(user, user_params) do
    user
    |> User.update_profile(user_params)
    |> Repo.update
  end

  def upload_avatar(user, user_params) do
    user
    |> User.upload_avatar(user_params)
    |> Repo.update
  end

  def update_password(user, user_params) do
    user
    |> User.update_password(user_params)
    |> Repo.update
  end

  def reset_password(user, user_params) do
    user
    |> User.reset_password(user_params)
    |> Repo.update
  end

  def set_reset_token(user, jti) do
    user
    |> User.set_reset_password_jti(%{"reset_password_jti" => jti})
    |> Repo.update
  end

  def update_locale(user, user_params) do
    user
    |> User.update_locale(user_params)
    |> Repo.update
  end

  defp create_user(params) do
    Multi.new
    |> Multi.insert(:user, User.changeset(%User{}, params))
    |> Multi.run(:avatar, fn %{user: user} ->
        upload_avatar(user, params)
      end)
    |> Repo.transaction
  end

  defp transaction_result({:ok, %{user: user}}),
    do: {:ok, user}
  defp transaction_result({:error, _entity, changeset, _changes_so_far}),
    do: {:error, changeset}
end
