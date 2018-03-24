defmodule VoyagerWeb.TripControllerTest do
  @moduledoc false
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.Planning.Trips

  # PUT :upload_cover
  @tag :login
  test "allows user to upload trip cover", %{conn: conn, logged_user: user} do
    trip = insert(:trip, author_id: user.id)

    conn =
      put(
        conn,
        "/trips/upload_cover",
        trip: %{
          cover: %Plug.Upload{path: "test/fixtures/cat.jpg", filename: "cat.jpg"},
          crop_x: "0",
          crop_y: "0",
          crop_width: "500",
          crop_height: "500"
        },
        id: trip.id
      )

    assert 200 == conn.status

    {:ok, updated_trip} = Trips.get(trip.id)
    assert updated_trip.cover
    assert updated_trip.cover.file_name == "cat.jpg"
  end

  @tag :login
  test "returns 403 in case if user is not member of the trip", %{conn: conn} do
    trip = insert(:trip)

    conn =
      put(
        conn,
        "/trips/upload_cover",
        trip: %{
          cover: %Plug.Upload{path: "test/fixtures/cat.jpg", filename: "cat.jpg"},
          crop_x: "0",
          crop_y: "0",
          crop_width: "500",
          crop_height: "500"
        },
        id: trip.id
      )

    assert 403 == conn.status
    {:ok, updated_trip} = Trips.get(trip.id)
    refute updated_trip.cover
  end
end
