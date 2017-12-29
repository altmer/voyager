defmodule VoyagerWeb.AccountsResolverTest do
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.AbsintheHelpers
  alias Voyager.Accounts.{Sessions, Users}

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
      json = conn
            |> post("/api", AbsintheHelpers.query_skeleton(query, "user"))
            |> json_response(200)

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
      json = conn
            |> post("/api", AbsintheHelpers.query_skeleton(query, "user"))
            |> json_response(200)

      assert json["data"]["user"] == nil
      assert [%{"message" => "not_found"} | _] = json["errors"]
    end
  end

  describe "register/3" do
    test "registers and returns user", %{conn: conn} do
      mutation = """
        mutation Register {
          register(
            name: "Test Testing",
            email: "test12344322@mail.test",
            password: "12345678",
            passwordConfirmation:"12345678",
            locale: "de"
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
      json = conn
            |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
            |> json_response(200)

      registered_user = Users.get_by_email("test12344322@mail.test")

      assert json["data"]["register"]["result"]["id"] == to_string(registered_user.id)
      assert json["data"]["register"]["successful"] == true

      assert "de" == registered_user.locale
      assert "Test Testing" == registered_user.name
      assert {:ok, _, _} = Sessions.authenticate(%{
        "email" => "test12344322@mail.test",
        "password" => "12345678"
      })
    end

    test "returns errors when input is invalid", %{conn: conn} do
      mutation = """
        mutation Register {
          register(
            name: "Test Testing",
            email: "test1234335552@mail.test",
            password: "12345678",
            passwordConfirmation:"123456789",
            locale: "de"
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
      json = conn
            |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
            |> json_response(200)
      assert json["data"]["register"]["result"]["id"] == nil
      assert json["data"]["register"]["successful"] == false

      assert [
        %{
          "field" => "passwordConfirmation",
          "message" => "does not match confirmation"
        }
      | _] = json["data"]["register"]["messages"]

      registered_user = Users.get_by_email("test1234335552@mail.test")
      assert registered_user == nil
    end

    test "returns errors in requested locale", %{conn: conn} do
      mutation = """
        mutation Register {
          register(
            name: "Test Testing",
            email: "test1234335552@mail.test",
            password: "12345678",
            passwordConfirmation:"123456789",
            locale: "ru"
          ) {
            successful
            messages {
              field
              message
            }
          }
        }
      """
      json = conn
            |> put_req_header("x-locale", "ru")
            |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
            |> json_response(200)
      assert json["data"]["register"]["successful"] == false

      assert [
        %{
          "field" => "passwordConfirmation",
          "message" => "не совпадает с подтверждением"
        }
      | _] = json["data"]["register"]["messages"]

      registered_user = Users.get_by_email("test1234335552@mail.test")
      assert registered_user == nil
    end
  end
end
