defmodule VoyagerWeb.UserViewTest do
  use VoyagerWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  # index.json
  test "renders application name" do
    json = render(VoyagerWeb.RootView, "index.json")
    assert json[:application] == "Voyager"
  end
end
