defmodule VoyagerWeb.PasswordsResolverTest do
  use VoyagerWeb.ConnCase
  use Bamboo.Test

  import Voyager.Factory

  alias Voyager.AbsintheHelpers
  alias Voyager.Accounts.Users
  alias Voyager.Guardian

  describe "&forgot_password/3" do
    test "send reset password email if user is found", %{conn: conn} do
      user = insert(:user)

      mutation = """
        mutation ForgotPassword {
          forgotPassword(email: "#{user.email}") {
            successful
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert json["data"]["forgotPassword"]["successful"]

      assert_email_delivered_with(
        to: [{user.name, user.email}],
        subject: "Password reset"
      )

      updated_user = Users.get!(user.id)
      assert updated_user.reset_password_jti != nil
    end

    test "silently does nothing when there is no such user", %{conn: conn} do
      mutation = """
        mutation ForgotPassword {
          forgotPassword(email: "some@email.com") {
            successful
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert json["data"]["forgotPassword"]["successful"]
      assert_no_emails_delivered()
    end
  end

  describe "&reset_password/3" do
    test "returns error if token is expired", %{conn: conn} do
      user = insert(:user)
      {:ok, jwt, %{"jti" => jti}} = Guardian.encode_and_sign(user, %{}, ttl: {-1, :hours})
      Users.set_reset_token(user, jti)

      mutation = """
        mutation ResetPassword {
          resetPassword(
            passwordResetToken: "#{jwt}",
            password: "test1234",
            passwordConfirmation: "test1234"
          ) {
            result {
              id
            }
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      refute json["data"]["resetPassword"]["successful"]
      assert [%{"message" => "token_expired"} | _] = json["errors"]

      updated_user = Users.get!(user.id)
      refute Bcrypt.verify_pass("test1234", updated_user.encrypted_password)
    end

    test "returns validations errors when data is not valid", %{conn: conn} do
      user = insert(:user)
      {:ok, jwt, %{"jti" => jti}} = Guardian.encode_and_sign(user)
      Users.set_reset_token(user, jti)

      mutation = """
        mutation ResetPassword {
          resetPassword(
            passwordResetToken: "#{jwt}",
            password: "test1234",
            passwordConfirmation: "test12345"
          ) {
            result {
              id
            }
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      refute json["data"]["resetPassword"]["successful"]

      assert [
               %{
                 "field" => "passwordConfirmation",
                 "message" => "does not match confirmation"
               }
               | _
             ] = json["data"]["resetPassword"]["messages"]

      updated_user = Users.get!(user.id)
      refute Bcrypt.verify_pass("test1234", updated_user.encrypted_password)
    end

    test "updates user's password", %{conn: conn} do
      user = insert(:user)
      {:ok, jwt, %{"jti" => jti}} = Guardian.encode_and_sign(user)
      Users.set_reset_token(user, jti)

      mutation = """
        mutation ResetPassword {
          resetPassword(
            passwordResetToken: "#{jwt}",
            password: "test1234",
            passwordConfirmation: "test1234"
          ) {
            result {
              id
            }
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert json["data"]["resetPassword"]["successful"]
      assert json["data"]["resetPassword"]["result"]["id"] == to_string(user.id)

      updated_user = Users.get!(user.id)
      assert Bcrypt.verify_pass("test1234", updated_user.encrypted_password)
    end
  end
end
