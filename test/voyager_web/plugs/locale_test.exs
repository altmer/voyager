defmodule VoyagerWeb.LocaleTest do
  use VoyagerWeb.ConnCase

  describe "call" do
    test "sets locale if locale is valid", %{conn: conn} do
      assert "en" = Gettext.get_locale(VoyagerWeb.Gettext)

      conn
      |> put_req_header("x-locale", "ru")
      |> VoyagerWeb.Plugs.Locale.call("en")

      assert "ru" = Gettext.get_locale(VoyagerWeb.Gettext)
    end

    test "sets default if locale is invalid", %{conn: conn} do
      assert "en" = Gettext.get_locale(VoyagerWeb.Gettext)

      conn
      |> put_req_header("x-locale", "fr")
      |> VoyagerWeb.Plugs.Locale.call("ru")

      assert "ru" = Gettext.get_locale(VoyagerWeb.Gettext)
    end

    test "sets default if locale is nil", %{conn: conn} do
      assert "en" = Gettext.get_locale(VoyagerWeb.Gettext)

      conn
      |> VoyagerWeb.Plugs.Locale.call("ru")

      assert "ru" = Gettext.get_locale(VoyagerWeb.Gettext)
    end
  end
end
