defmodule Voyager.Planning.Trips do
  @moduledoc """
  Functions for accessing trips
  """

  alias Voyager.Repo
  alias Voyager.Planning.Trip

  def add(user, params) do
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
    |> Trip.changeset(%{archived: true})
    |> Repo.update()
  end

  def upload_cover(nil, _), do: {:error, :not_found}

  def upload_cover(%Trip{} = trip, params) do
    trip
    |> Trip.upload_cover(params)
    |> Repo.update()
  end
end
