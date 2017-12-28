defmodule VoyagerWeb.AccountsResolverTest do
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.AbsintheHelpers

  describe "&find_user/3" do
    test "returns user", %{conn: conn} do
      user = insert(:user)

      query = """
      {
        user(id: "#{user.id}") {
          id
          name
          locale
          currency
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
    end
  end
end
