defmodule VoyagerWeb.RootView do
  use VoyagerWeb, :view

  def render("index.json", _assigns), do: %{application: "Voyager"}
end
