defmodule VoyagerWeb.Plugs.Context do
  @moduledoc """
  Puts authenticated resource into absinthe context
  """
  @behaviour Plug

  import Plug.Conn
  alias Voyager.Guardian.Plug

  def init(opts), do: opts

  def call(conn, _),
    do: conn_with_resource(conn, Plug.current_resource(conn))

  defp conn_with_resource(conn, nil),
    do: conn
  defp conn_with_resource(conn, user),
    do: put_private(conn, :absinthe, %{context: %{current_user: user}})
end