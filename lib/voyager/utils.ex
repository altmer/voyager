defmodule Voyager.Utils do
  @moduledoc """
  Provides application-level utility functions.
  """
  def timestamp do
    {mgsec, sec, _usec} = :os.timestamp
    mgsec * 1_000_000 + sec
  end
end
