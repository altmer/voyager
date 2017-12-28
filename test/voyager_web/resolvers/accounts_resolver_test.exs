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
          color
          avatar_thumb
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
      assert json["data"]["user"]["color"] =~ ~r/user-color-[0-3]/
      assert json["data"]["user"]["avatar_thumb"] == nil
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

    test "returns error if user is not found", %{conn: conn} do
      query = """
      {
        user(id: "7D72616A-AF20-40FC-ADAA-179C85CFA638") {
          id
        }
      }
      """
      res = conn
            |> post("/api", AbsintheHelpers.query_skeleton(query, "user"))

      json = json_response(res, 200)
      assert json["data"]["user"] == nil
      assert [%{"message" => "not_found"} | _] = json["errors"]
    end
  end
end
