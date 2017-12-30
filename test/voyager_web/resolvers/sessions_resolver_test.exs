defmodule VoyagerWeb.SessionsResolverTest do
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.Guardian
  alias Voyager.AbsintheHelpers

  describe "&login/3" do
    test "checks password and generates token", %{conn: conn} do
      user = insert(:user)

      mutation = """
        mutation Login {
          login(
            email: "#{user.email}",
            password: "12345678",
          ) {
            token
          }
        }
      """

      json = conn
             |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
             |> json_response(200)

      token = json["data"]["login"]["token"]
      {
        :ok,
        {claims, _}
      } = Guardian.decode_and_verify(token)

      assert {:ok, token_user} = Guardian.resource_from_claims({claims, token})
      assert token_user.id == user.id
    end

    test "returns error on failed authentication", %{conn: conn} do
      user = insert(:user)

      mutation = """
        mutation Login {
          login(
            email: "#{user.email}",
            password: "123456789",
          ) {
            token
          }
        }
      """

      json = conn
             |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
             |> json_response(200)

      assert [%{"message" => "auth_failed"} | _] = json["errors"]
    end
  end

  describe "&logout/3" do
    @tag :login
    test "revokes current token", %{conn: conn} do
      token = Guardian.Plug.current_token(conn)
      assert {:ok, _} = Guardian.decode_and_verify(token)

      mutation = """
        mutation Logout {
          logout {
            successful
          }
        }
      """

      json = conn
             |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
             |> json_response(200)

      assert json["data"]["logout"]["successful"]
      assert {:error, :token_not_found} = Guardian.decode_and_verify(token)
    end

    test "returns error when not logged in", %{conn: conn} do
      mutation = """
        mutation Logout {
          logout {
            successful
          }
        }
      """

      json = conn
             |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
             |> json_response(200)

      assert [%{"message" => "not_authorized"} | _] = json["errors"]
    end
  end
end
