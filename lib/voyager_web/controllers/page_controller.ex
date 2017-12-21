defmodule VoyagerWeb.PageController do
  use VoyagerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
