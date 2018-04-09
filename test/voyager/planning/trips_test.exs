defmodule Voyager.Planning.TripsTest do
  @moduledoc false
  use Voyager.DataCase

  import Voyager.Factory

  alias Voyager.Repo
  alias Voyager.Planning.{Trip, Trips}

  describe "add/2" do
    @valid_attrs %{
      name: "Venice on weekend",
      short_description: "Italian getaway",
      start_date: "2018-04-13",
      duration: 3,
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2
    }

    test "it creates valid trip" do
      user = insert(:user)

      assert {:ok, trip} = Trips.add(@valid_attrs, user)

      assert @valid_attrs.name == trip.name
      assert @valid_attrs.short_description == trip.short_description
      assert ~D[2018-04-13] == trip.start_date
      assert @valid_attrs.duration == trip.duration
      assert @valid_attrs.currency == trip.currency
      assert @valid_attrs.status == trip.status
      assert @valid_attrs.private === trip.private
      assert @valid_attrs.people_count_for_budget == trip.people_count_for_budget

      trip = Repo.get!(Trip, trip.id)
      assert false == trip.archived
      assert user.id == trip.author_id
    end

    @invalid_attrs %{
      name: "",
      short_description: "Italian getaway",
      start_date: "2018-04-13",
      duration: 3,
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2
    }

    test "it returns error if params are invalid" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Trips.add(@invalid_attrs, user)
    end

    @invalid_attrs_date %{
      name: "Venice",
      short_description: "Italian getaway",
      duration: 3,
      currency: "EUR",
      status: "2_finished",
      private: false,
      people_count_for_budget: 2
    }

    test "start_date is required when status is finished" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Trips.add(@invalid_attrs_date, user)
    end
  end
end
