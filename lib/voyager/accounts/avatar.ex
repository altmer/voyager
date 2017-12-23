defmodule Voyager.Accounts.Avatar do
  @moduledoc """
  User avatar file upload definition.
  """
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]

  def transform(:original, {_, scope}) do
    {
      :convert,
      crop_string(scope),
      :png
    }
  end

  def transform(:thumb, {_, scope}) do
    {
      :convert,
      crop_string(scope) <> " " <> "-strip -thumbnail 100x100^ -gravity center -extent 100x100",
      :png
    }
  end

  def filename(version, _), do: version

  def storage_dir(_, {_, scope}) do
    folder = Base.encode16(:crypto.hash(:md5, Integer.to_string(scope.id)))
    "uploads/users/#{folder}/avatar"
  end

  defp crop_string(s),
    do: crop_string(s.crop_width, s.crop_height, s.crop_x, s.crop_y)
  defp crop_string(nil, nil, nil, nil),
    do: base_params()
  defp crop_string(crop_width, crop_height, crop_x, crop_y),
    do: "-crop #{crop_width}x#{crop_height}+#{crop_x}+#{crop_y} #{base_params()}"

  defp base_params, do: "-format png -limit area 10MB -limit disk 100MB"
end
