defmodule VoyagerWeb.RootControllerTest do
  use VoyagerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert json_response(conn, 200)["application"] == "Voyager"
  end
end
