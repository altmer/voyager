defmodule VoyagerWeb.AccountsResolverTest do
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.AbsintheHelpers

  describe "&find_user/3" do
    test "returns user", %{conn: conn} do
      user = insert(:user, name: "John Doe")

      query = """
      {
        user(id: "#{user.id}") {
          id
          name
          locale
          currency
          initials
        }
      }
      """
      res = conn
            |> post("/api", AbsintheHelpers.query_skeleton(query, "user"))

      json = json_response(res, 200)
      assert json["data"]["user"]["id"] == to_string(user.id)
      assert json["data"]["user"]["name"] == user.name
      assert json["data"]["user"]["locale"] == user.locale
      assert json["data"]["user"]["currency"] == user.currency
      assert json["data"]["user"]["initials"] == "JD"
    end

    test "correct initials when one word name", %{conn: conn} do
      user = insert(:user, name: "test")

      query = """
      {
        user(id: "#{user.id}") {
          id
          initials
        }
      }
      """
      res = conn
            |> post("/api", AbsintheHelpers.query_skeleton(query, "user"))

      json = json_response(res, 200)
      assert json["data"]["user"]["id"] == to_string(user.id)
      assert json["data"]["user"]["initials"] == "T"
    end
  end
end
