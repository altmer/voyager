defmodule VoyagerWeb.UserControllerTest do
  use VoyagerWeb.ConnCase

  alias Voyager.Accounts.Users

  # PUT :upload_avatar
  @tag :login
  test "allows logged user to upload avatar", %{conn: conn, logged_user: user} do
    conn = put conn, "/upload_avatar", user: %{
      avatar: %Plug.Upload{path: "test/fixtures/cat.jpg", filename: "cat.jpg"},
      crop_x: "0",
      crop_y: "0",
      crop_width: "500",
      crop_height: "500"
    }

    assert 200 == conn.status

    updated_user = Users.get!(user.id)
    assert updated_user.avatar
    assert updated_user.avatar.file_name == "cat.jpg"
  end

  test "returns 404 in case of missing authorization", %{conn: conn} do
    conn = put conn, "/upload_avatar", user: %{
      avatar: %Plug.Upload{path: "test/fixtures/cat.jpg", filename: "cat.jpg"},
      crop_x: "0",
      crop_y: "0",
      crop_width: "200",
      crop_height: "200"
    }

    assert 404 == conn.status
  end
end
