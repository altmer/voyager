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
      dates_unknown: false,
      start_date: "2018-04-13",
      end_date: "2018-04-15",
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
      assert 3 == trip.duration
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
      dates_unknown: false,
      start_date: "2018-04-13",
      end_date: "2018-04-15",
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2
    }

    test "it returns error if params are invalid" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{errors: [name: {"can't be blank", [validation: :required]}]}} =
               Trips.add(@invalid_attrs, user)
    end

    @invalid_attrs_date %{
      name: "Venice",
      short_description: "Italian getaway",
      dates_unknown: true,
      duration: 3,
      currency: "EUR",
      status: "2_finished",
      private: false,
      people_count_for_budget: 2
    }

    test "dates are required when status is finished" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  start_date: {"can't be blank", [validation: :required]},
                  end_date: {"can't be blank", [validation: :required]}
                ]
              }} = Trips.add(@invalid_attrs_date, user)
    end

    @valid_attrs_no_dates %{
      name: "Venice on weekend",
      short_description: "Italian getaway",
      dates_unknown: true,
      duration: 3,
      startDate: "2018-04-13",
      endDate: "2018-04-15",
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2
    }

    test "it creates valid trip without dates" do
      user = insert(:user)

      assert {:ok, trip} = Trips.add(@valid_attrs_no_dates, user)

      assert @valid_attrs.name == trip.name
      assert @valid_attrs.short_description == trip.short_description
      assert nil == trip.start_date
      assert 3 == trip.duration
      assert @valid_attrs.currency == trip.currency
      assert @valid_attrs.status == trip.status
      assert @valid_attrs.private === trip.private
      assert @valid_attrs.people_count_for_budget == trip.people_count_for_budget

      trip = Repo.get!(Trip, trip.id)
      assert false == trip.archived
      assert user.id == trip.author_id
    end

    @invalid_attrs_no_end_date %{
      name: "Venice",
      short_description: "Italian getaway",
      dates_unknown: false,
      start_date: "2018-04-13",
      currency: "EUR",
      status: "2_finished",
      private: false,
      people_count_for_budget: 2
    }

    test "end date is required when dates are known" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  end_date: {"can't be blank", [validation: :required]}
                ]
              }} = Trips.add(@invalid_attrs_no_end_date, user)
    end

    @invalid_duration %{
      name: "Venice",
      short_description: "Italian getaway",
      dates_unknown: true,
      duration: 0,
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2
    }

    test "duration should be positive" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  duration: {"is invalid", [validation: :inclusion, enum: 1..30]}
                ]
              }} = Trips.add(@invalid_duration, user)
    end

    @invalid_dates_period %{
      name: "Venice on weekend",
      short_description: "Italian getaway",
      dates_unknown: false,
      start_date: "2018-04-13",
      end_date: "2018-04-12",
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2
    }
    test "end date should come after start date" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  end_date: {"trip duration invalid", []}
                ]
              }} = Trips.add(@invalid_dates_period, user)
    end
  end
end
