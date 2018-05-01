defmodule VoyagerWeb.TripsResolverTest do
  @moduledoc false
  use VoyagerWeb.ConnCase

  import Voyager.Factory

  alias Voyager.AbsintheHelpers
  alias Voyager.Planning.Trip
  alias Voyager.Repo

  @tag :login
  describe "create/3" do
    test "creates and returns trip", %{conn: conn, logged_user: logged_user} do
      mutation = """
        mutation CreateTrip {
          createTrip(
            input: {
              name: "Wernigerode",
              shortDescription: "City break",
              datesUnknown: false,
              startDate: "2018-03-12T00:00:00.000Z",
              endDate: "2018-03-14T00:00:00.000Z",
              duration: 5,
              currency: "EUR",
              status: "1_planned",
              peopleCountForBudget: 2,
              private: false
            }
          ) {
            result {
              name
              shortDescription
              startDate
              duration
              currency
              status
              peopleCountForBudget
            }
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert "Wernigerode" = json["data"]["createTrip"]["result"]["name"]
      assert true = json["data"]["createTrip"]["successful"]

      created_trip = Repo.get_by(Trip, name: "Wernigerode")

      assert "City break" = created_trip.short_description
      assert ~D[2018-03-12] = created_trip.start_date
      assert 3 = created_trip.duration
      assert "EUR" = created_trip.currency
      assert "1_planned" = created_trip.status
      assert 2 = created_trip.people_count_for_budget
      assert logged_user.id == created_trip.author_id
      assert false == created_trip.private
    end

    @tag :login
    test "returns errors when input is invalid", %{conn: conn} do
      mutation = """
        mutation CreateTrip {
          createTrip(
            input: {
              name: "Wernigerode",
              shortDescription: "City break",
              datesUnknown: false,
              startDate: "2018-03-12T00:00:00.000Z",
              endDate: "2018-04-18T00:00:00.000Z",
              currency: "EUR",
              status: "1_planned",
              peopleCountForBudget: 2
            }
          ) {
            result {
              name
            }
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert json["data"]["createTrip"]["result"]["id"] == nil
      assert json["data"]["createTrip"]["successful"] == false

      assert [
               %{
                 "field" => "endDate",
                 "message" => "trip duration invalid"
               }
               | _
             ] = json["data"]["createTrip"]["messages"]

      assert nil == Repo.get_by(Trip, name: "Wernigerode")
    end
  end

  describe "update/3" do
    @tag :login
    test "updates and returns trip", %{conn: conn, logged_user: logged_user} do
      trip = insert(:trip, author_id: logged_user.id)

      mutation = """
        mutation UpdateTrip {
          updateTrip(
            id: "#{trip.id}",
            input: {
              name: "New name",
              datesUnknown: true,
              duration: 5
            }
          ) {
            result {
              name
              duration
            }
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert true = json["data"]["updateTrip"]["successful"]
      assert "New name" = json["data"]["updateTrip"]["result"]["name"]
      assert 5 = json["data"]["updateTrip"]["result"]["duration"]

      updated_trip = Repo.get_by(Trip, name: "New name")

      assert "New name" = updated_trip.name
      assert "Italian getaway" = updated_trip.short_description
      assert 5 = updated_trip.duration
      assert logged_user.id == updated_trip.author_id
    end

    @tag :login
    test "return not authorized error if user is not participant", %{
      conn: conn
    } do
      trip = insert(:trip)

      mutation = """
        mutation UpdateTrip {
          updateTrip(
            id: "#{trip.id}",
            input: {
              name: "New name"
            }
          ) {
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert [
               %{
                 "message" => "not_authorized"
               }
               | _
             ] = json["errors"]

      updated_trip = Repo.get(Trip, trip.id)
      assert updated_trip.name != "New name"
    end

    @tag :login
    test "returns validation errors", %{
      conn: conn,
      logged_user: logged_user
    } do
      trip = insert(:trip, author_id: logged_user.id)

      mutation = """
        mutation UpdateTrip {
          updateTrip(
            id: "#{trip.id}",
            input: {
              name: "New name",
              currency: ""
            }
          ) {
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert json["data"]["updateTrip"]["successful"] == false

      assert [
               %{
                 "field" => "currency",
                 "message" => "can't be blank"
               }
               | _
             ] = json["data"]["updateTrip"]["messages"]

      updated_trip = Repo.get(Trip, trip.id)
      assert updated_trip.name != "New name"
    end
  end

  describe "delete/3" do
    @tag :login
    test "marks trip as archived", %{conn: conn, logged_user: logged_user} do
      trip = insert(:trip, author_id: logged_user.id)

      mutation = """
        mutation DeleteTrip {
          deleteTrip(
            id: "#{trip.id}",
          ) {
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert true = json["data"]["deleteTrip"]["successful"]

      assert nil != Repo.get_by(Trip, id: trip.id, archived: true)
    end

    @tag :login
    test "return not authorized error if user is not author", %{
      conn: conn
    } do
      trip = insert(:trip)

      mutation = """
        mutation DeleteTrip {
          deleteTrip(
            id: "#{trip.id}"
          ) {
            successful
            messages {
              field
              message
            }
          }
        }
      """

      json =
        conn
        |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
        |> json_response(200)

      assert [
               %{
                 "message" => "not_authorized"
               }
               | _
             ] = json["errors"]

      assert nil == Repo.get_by(Trip, id: trip.id, archived: true)
    end
  end
end
