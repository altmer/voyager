defmodule Voyager.Config do
  @moduledoc """
  App config accessors
  """
  def frontend_url, do: Application.get_env(:voyager, :frontend_url)
end
