defmodule VoyagerWeb.RootController do
  use VoyagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json")
  end
end
