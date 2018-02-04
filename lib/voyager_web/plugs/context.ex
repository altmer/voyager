defmodule VoyagerWeb.Plugs.Context do
  @moduledoc """
  Puts authenticated resource into absinthe context
  """
  @behaviour Plug

  import Plug.Conn
  alias Voyager.Guardian.Plug, as: GuardianPlug

  def init(opts), do: opts

  def call(conn, _),
    do:
      conn_with_resource(
        conn,
        GuardianPlug.current_resource(conn),
        GuardianPlug.current_token(conn),
        GuardianPlug.current_claims(conn)
      )

  defp conn_with_resource(conn, nil, _, _), do: conn

  defp conn_with_resource(conn, user, token, claims),
    do:
      put_private(conn, :absinthe, %{
        context: %{current_user: user, token: token, claims: claims}
      })
end
