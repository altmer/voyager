defmodule VoyagerWeb.TripController do
  use VoyagerWeb, :controller

  alias Voyager.Planning.Trips
  alias Voyager.Guardian.Plug, as: GuardianPlug

  require Logger

  plug(Guardian.Plug.EnsureAuthenticated)
  plug(:scrub_params, "trip")

  def upload_cover(conn, %{"trip" => trip_params, "id" => trip_id}) do
    with current_user <- GuardianPlug.current_resource(conn),
         {:ok, trip} <- Trips.get(trip_id),
         :ok <- Trips.authorize(:upload_cover, current_user, trip) do
      trip
      |> Trips.upload_cover(trip_params)
      |> render_response(conn)
    else
      res ->
        render_response(res, conn)
    end
  end

  defp render_response({:error, :not_authorized}, conn), do: send_resp(conn, 403, "")
  defp render_response({:error, :not_found}, conn), do: send_resp(conn, 404, "")
  defp render_response({:error, %Ecto.Changeset{}}, conn), do: send_resp(conn, 422, "")
  defp render_response({:ok, _}, conn), do: send_resp(conn, 200, "")
end
