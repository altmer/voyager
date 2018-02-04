defmodule VoyagerWeb.UserController do
  use VoyagerWeb, :controller

  alias Voyager.Accounts.Users
  alias Voyager.Guardian.Plug, as: GuardianPlug

  require Logger

  plug(:scrub_params, "user")

  def upload_avatar(conn, %{"user" => user_params}) do
    conn
    |> GuardianPlug.current_resource()
    |> Users.upload_avatar(user_params)
    |> render_response(conn)
  end

  defp render_response({:error, :not_found}, conn), do: send_resp(conn, 404, "")
  defp render_response({:error, %Ecto.Changeset{}}, conn), do: send_resp(conn, 422, "")
  defp render_response({:ok, _}, conn), do: send_resp(conn, 200, "")
end
