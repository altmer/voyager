defmodule VoyagerWeb.SessionsResolverTest do
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.Guardian
  alias Voyager.AbsintheHelpers

  describe "&login/3" do
    test "checks password, generates token and returns currentUser", %{conn: conn} do
      user = insert(:user)

      mutation = """
        mutation Login {
          login(
            email: "#{user.email}",
            password: "12345678",
          ) {
            token
            currentUser {
              id
              name
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      token = json["data"]["login"]["token"]

      {
        :ok,
        {claims, _}
      } = Guardian.decode_and_verify(token)

      assert {:ok, token_user} = Guardian.resource_from_claims({claims, token})
      assert token_user.id == user.id

      current_user = json["data"]["login"]["currentUser"]
      assert current_user["id"] == user.id
      assert current_user["name"] == user.name
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

      json =
        conn
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

      json =
        conn
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

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert [%{"message" => "not_authorized"} | _] = json["errors"]
    end
  end

  describe "&current_user/3" do
    @tag :login
    test "returns current user", %{conn: conn, logged_user: user} do
      query = """
      {
        currentUser {
          id
          name
        }
      }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.query_skeleton(query, "CurrentUser"))
        |> json_response(200)

      assert json["data"]["currentUser"]["id"] == to_string(user.id)
      assert json["data"]["currentUser"]["name"] == user.name
    end

    test "returns error when not logged in", %{conn: conn} do
      query = """
      {
        currentUser {
          id
          name
        }
      }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.query_skeleton(query, "CurrentUser"))
        |> json_response(200)

      assert [%{"message" => "not_authorized"} | _] = json["errors"]
    end
  end
end
