defmodule Voyager.PasswordsTest do
  @moduledoc """
  Tests for Passwords module
  """
  use Voyager.DataCase
  use Bamboo.Test

  import Voyager.Factory

  alias Comeonin.Bcrypt
  alias Voyager.Guardian
  alias Voyager.Repo
  alias Voyager.Accounts.{AuthToken, Passwords, User, Users}
  alias VoyagerWeb.Endpoint

  describe "Passwords.send_reset_password_email/1" do
    test "it sends reset password email if user with given email exists" do
      user = insert(:user)

      assert {
               :ok,
               emailed_user
             } = Passwords.send_reset_password_email(user.email)

      assert user.id == emailed_user.id

      assert_delivered_with(
        to: [{user.name, user.email}],
        subject: "Password reset"
      )

      user = Repo.get(User, user.id)
      assert user.reset_password_jti != nil
    end

    test "it does not send email and returns error code if there is no user" do
      assert {:error, :not_found} = Passwords.send_reset_password_email("dd@web.de")
      assert_no_emails_delivered()
    end
  end

  describe "Passwords.generate_reset_token" do
    test "it returns error when called with nil" do
      assert {:error, :not_found} = Passwords.generate_reset_token(nil)
    end

    test "it returns user together with correct jwt token and jti claim when called with user" do
      user = insert(:user)

      assert %{
               user: ^user,
               jwt: jwt,
               jti: jti_returned
             } = Passwords.generate_reset_token(user)

      {
        :ok,
        %{"iat" => iat, "exp" => exp, "jti" => jti} = claims
      } = Guardian.decode_and_verify(jwt)

      assert jti == jti_returned
      # token expires in 1 hour
      assert exp == iat + 60 * 60
      assert {:ok, authorized_user} = Guardian.resource_from_claims(claims)
      assert user.id == authorized_user.id
    end
  end

  describe "Passwords.set_reset_token" do
    test "it returns error if receives error value" do
      assert {
               :error,
               :any_error
             } = Passwords.set_reset_token({:error, :any_error})
    end

    test "it updates user with jti value" do
      user = insert(:user)

      assert %{user: %User{}, jwt: "jwt token"} =
               Passwords.set_reset_token(%{
                 user: user,
                 jwt: "jwt token",
                 jti: "reset password jti"
               })

      user = Repo.get(User, user.id)
      assert "reset password jti" == user.reset_password_jti
    end
  end

  describe "Passwords.reset_password_link" do
    test "it returns link to reset password with given token" do
      link = Passwords.reset_password_link("jwt_token")
      uri = URI.parse(link)
      assert uri.host == Endpoint.config(:url)[:host]

      token =
        uri.path
        |> String.split("/")
        |> Enum.fetch!(-1)

      assert "jwt_token" == token
    end
  end

  describe "Passwords.reset_password" do
    @valid_password_params %{
      password: "new_password",
      password_confirmation: "new_password"
    }
    @wrong_password_confirmation %{
      password: "new_password",
      password_confirmation: "new_password2"
    }

    test "returns auth error on invalid token" do
      assert {:error, %CaseClauseError{}} =
               Passwords.reset_password(
                 "not a token",
                 @valid_password_params
               )
    end

    test "returns auth error on expired token" do
      user = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(user, %{}, ttl: {-1, :hours})

      assert {:error, :token_expired} =
               Passwords.reset_password(
                 jwt,
                 @valid_password_params
               )

      user = Repo.get(User, user.id)
      refute Bcrypt.checkpw("new_password", user.encrypted_password)
    end

    test "returns auth error if user does not exist anymore" do
      user = insert(:user)
      {:ok, jwt, _} = Guardian.encode_and_sign(user, %{}, ttl: {1, :hours})
      Repo.delete_all(AuthToken)
      Repo.delete!(user)

      assert {:error, :token_not_found} =
               Passwords.reset_password(
                 jwt,
                 @valid_password_params
               )
    end

    test "returns auth error if token is valid but not for password reset" do
      user = insert(:user)
      refute Bcrypt.checkpw("new_password", user.encrypted_password)

      {:ok, jwt, _} =
        Guardian.encode_and_sign(
          user,
          %{},
          ttl: {1, :hours}
        )

      assert {:error, :invalid_token} =
               Passwords.reset_password(
                 jwt,
                 @valid_password_params
               )

      user = Repo.get(User, user.id)
      refute Bcrypt.checkpw("new_password", user.encrypted_password)
    end

    test "returns changeset error if password params are invalid" do
      user = insert(:user)

      {
        :ok,
        jwt,
        %{"jti" => jti}
      } = Guardian.encode_and_sign(user, %{}, ttl: {1, :hours})

      {:ok, user} = Users.set_reset_token(user, jti)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Passwords.reset_password(
                 jwt,
                 @wrong_password_confirmation
               )

      refute changeset.valid?
      assert {:ok, _claims} = Guardian.decode_and_verify(jwt)

      user = Repo.get(User, user.id)
      refute Bcrypt.checkpw("new_password", user.encrypted_password)
    end

    test "updates password if params are valid and invalidates token" do
      user = insert(:user)
      refute Bcrypt.checkpw("new_password", user.encrypted_password)

      {:ok, jwt, %{"jti" => jti}} =
        Guardian.encode_and_sign(
          user,
          %{},
          ttl: {1, :hours}
        )

      {:ok, user} = Users.set_reset_token(user, jti)

      assert {:ok, updated_user} =
               Passwords.reset_password(
                 jwt,
                 @valid_password_params
               )

      assert updated_user.id == user.id

      assert Bcrypt.checkpw(
               "new_password",
               updated_user.encrypted_password
             )

      assert {:error, :token_not_found} = Guardian.decode_and_verify(jwt)
    end
  end
end
