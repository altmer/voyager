defmodule Voyager.Accounts.AuthTokens do
  @moduledoc """
    Common functionality for auth tokens
  """
  import Ecto.Query

  alias Voyager.Repo
  alias Voyager.Utils
  alias Voyager.Accounts.AuthToken

  def purge_expired,
    do: Repo.delete_all(expired_query())

  defp expired_query do
    timestamp = Utils.timestamp()
    from t in AuthToken,
      where: t.exp < ^timestamp
  end
end
