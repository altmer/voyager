defmodule Voyager.Planning.Trips do
  @moduledoc """
  Functions for accessing trips
  """
  @behaviour Voyager.Policy

  alias Voyager.Repo
  alias Voyager.Accounts.User
  alias Voyager.Planning.Trip

  def get(id) do
    id
    |> Trip.by_id()
    |> Repo.one()
    |> single_result()
  end

  def add(params, user) do
    %Trip{author_id: user.id}
    |> Trip.changeset(params)
    |> Repo.insert()
  end

  def update(nil, _), do: {:error, :not_found}

  # TODO: when trip duration changed, update dependent objects
  def update(%Trip{} = trip, params) do
    trip
    |> Trip.changeset(params)
    |> Repo.update()
  end

  def delete(nil), do: {:error, :not_found}

  def delete(%Trip{} = trip) do
    trip
    |> Trip.archive_changeset(%{archived: true})
    |> Repo.update()
  end

  def upload_cover(nil, _), do: {:error, :not_found}

  def upload_cover(%Trip{} = trip, params) do
    trip
    |> Trip.upload_cover(params)
    |> Repo.update()
  end

  def authorize(:add, _, _), do: :ok
  def authorize(:update, user, trip), do: authorize_member(user, trip)
  def authorize(:delete, user, trip), do: authorize_author(user, trip)
  def authorize(:upload_cover, user, trip), do: authorize_member(user, trip)

  defp authorize_member(user, trip), do: authorize_author(user, trip)

  defp authorize_author(%User{id: user_id}, %Trip{author_id: author_id})
       when author_id == user_id,
       do: :ok

  defp authorize_author(_, _), do: {:error, :not_authorized}

  defp single_result(nil), do: {:error, :not_found}
  defp single_result(trip), do: {:ok, trip}
end
