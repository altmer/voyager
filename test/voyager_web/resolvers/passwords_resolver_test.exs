defmodule VoyagerWeb.PasswordsResolverTest do
  use VoyagerWeb.ConnCase
  use Bamboo.Test

  import Voyager.Factory

  alias Voyager.AbsintheHelpers
  alias Voyager.Accounts.Users

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

      json = conn
             |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
             |> json_response(200)

      assert json["data"]["forgotPassword"]["successful"]
      assert_delivered_with(
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

      json = conn
             |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
             |> json_response(200)

      assert json["data"]["forgotPassword"]["successful"]
      assert_no_emails_delivered()
    end
  end
end
