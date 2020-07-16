defmodule Voyager.Factory do
  @moduledoc """
  Factories
  """
  use ExMachina.Ecto, repo: Voyager.Repo

  alias Comeonin.Bcrypt
  alias Faker.{Person, Internet}
  alias Voyager.Accounts.User
  alias Voyager.Planning.Trip

  def user_factory do
    %User{
      name: Person.name(),
      email: Internet.safe_email(),
      encrypted_password: Bcrypt.hashpwsalt("12345678"),
      home_town_id: "1234",
      currency: "EUR"
    }
  end

  def trip_factory do
    user = insert(:user)

    %Trip{
      name: "Venice on weekend",
      short_description: "Italian getaway",
      start_date: "2018-04-13",
      duration: 3,
      currency: "EUR",
      status: "1_planned",
      private: false,
      people_count_for_budget: 2,
      author_id: user.id
    }
  end
end
