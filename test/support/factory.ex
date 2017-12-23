defmodule Voyager.Factory do
  use ExMachina.Ecto, repo: Voyager.Repo

  alias Voyager.Accounts.User

  def user_factory do
    %User{
      name: Faker.Name.name,
      email: Faker.Internet.safe_email,
      encrypted_password: Comeonin.Bcrypt.hashpwsalt("12345678"),
      home_town_id: "1234",
      currency: "EUR"
    }
  end
end
