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

      assert {:ok, token_user} = Guardian.resource_from_claims(claims)
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
end
