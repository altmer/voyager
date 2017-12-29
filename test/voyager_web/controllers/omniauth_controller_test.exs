defmodule VoyagerWeb.OmniauthControllerTest do
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.Guardian
  alias VoyagerWeb.OmniauthController

  describe "GET :callback" do
    test "redirects with error if ueberauth returns failure", %{conn: conn} do
      redirect_path =
        conn
        |> assign(:ueberauth_failure, %{error: "error"})
        |> OmniauthController.callback(%{})
        |> redirected_to()

      assert redirect_path == "/sessions/auth?result=failure"
    end

    test "redirects to success if user with given email exists", %{conn: conn} do
      user = insert(:user)

      redirect_path =
        conn
        |> assign(
            :ueberauth_auth, %{provider: :google, info: %{email: user.email}}
           )
        |> OmniauthController.callback(%{})
        |> redirected_to()

      assert redirect_path =~ "/sessions/auth?result=success&token="
      assert %{"jwt" => jwt} = Regex.named_captures(
        ~r/\/sessions\/auth\?result=success&token=(?<jwt>.+)/,
        redirect_path
      )

      {:ok, {claims, _}} = Guardian.decode_and_verify(jwt)
      assert {:ok, auth_user} = Guardian.resource_from_claims({claims, jwt})

      assert auth_user.id == user.id
    end

    test "redirects to success if user does not exist", %{conn: conn} do
      redirect_path =
        conn
        |> assign(
             :ueberauth_auth,
             %{
                provider: :google,
                info: %{
                  email: "someemail@mail.test",
                  first_name: "Paul",
                  last_name: "Richey",
                  image: nil
                }
             }
           )
        |> OmniauthController.callback(%{})
        |> redirected_to()

      assert redirect_path =~ "/sessions/auth?result=success&token="
      assert %{"jwt" => jwt} = Regex.named_captures(
        ~r/\/sessions\/auth\?result=success&token=(?<jwt>.+)/,
        redirect_path
      )

      {:ok, {claims, _}} = Guardian.decode_and_verify(jwt)
      assert {:ok, auth_user} = Guardian.resource_from_claims({claims, jwt})

      assert auth_user.email == "someemail@mail.test"
    end

    test "redirects to failure if params are not valid", %{conn: conn} do
      redirect_path =
        conn
        |> assign(
             :ueberauth_auth,
             %{
                provider: :google,
                info: %{
                  email: nil,
                  first_name: nil,
                  last_name: nil,
                  image: nil
                }
             }
           )
        |> OmniauthController.callback(%{})
        |> redirected_to()

        assert redirect_path == "/sessions/auth?result=failure"
    end
  end
end
