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
              startDate: "2018-03-12",
              duration: 3,
              currency: "EUR",
              status: "1_planned",
              peopleCountForBudget: 2
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
    end

    @tag :login
    test "returns errors when input is invalid", %{conn: conn} do
      mutation = """
        mutation CreateTrip {
          createTrip(
            input: {
              name: "Wernigerode",
              shortDescription: "City break",
              startDate: "2018-03-12",
              duration: 32,
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
                 "field" => "duration",
                 "message" => "is invalid"
               }
               | _
             ] = json["data"]["createTrip"]["messages"]

      assert nil == Repo.get_by(Trip, name: "Wernigerode")
    end
  end

  @tag :login
  describe "update/3" do
    test "updates and returns trip", %{conn: conn, logged_user: logged_user} do
      trip = insert(:trip, author_id: logged_user.id)

      mutation = """
        mutation UpdateTrip {
          updateTrip(
            id: "#{trip.id}",
            input: {
              name: "New name",
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

    # test "updates and returns trip", %{conn: conn, logged_user: logged_user} do
    #   trip = insert(:trip, author_id: logged_user.id)

    #   mutation = """
    #     mutation UpdateTrip {
    #       updateTrip(
    #         input: {
    #           name: "New name",
    #           duration: 5
    #         }
    #       ) {
    #         result {
    #           name
    #           duration
    #         }
    #         successful
    #         messages {
    #           field
    #           message
    #         }
    #       }
    #     }
    #   """

    #   json =
    #     conn
    #     |> post("/api", AbsintheHelpers.mutation_skeleton(mutation))
    #     |> json_response(200)

    #   assert true = json["data"]["updateTrip"]["successful"]
    #   assert "New name" = json["data"]["updateTrip"]["result"]["name"]
    #   assert 5 = json["data"]["updateTrip"]["result"]["duration"]

    #   updated_trip = Repo.get_by(Trip, name: "New name")

    #   assert "Italian getaway" = updated_trip.short_description
    #   assert 5 = updated_trip.duration
    #   assert logged_user.id == updated_trip.author_id
    # end
  end
end
