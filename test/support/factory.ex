defmodule Voyager.Factory do
  @moduledoc """
  Factories
  """
  use ExMachina.Ecto, repo: Voyager.Repo

  alias Comeonin.Bcrypt
  alias Faker.{Name, Internet}
  alias Voyager.Accounts.User

  def user_factory do
    %User{
      name: Name.name(),
      email: Internet.safe_email(),
      encrypted_password: Bcrypt.hashpwsalt("12345678"),
      home_town_id: "1234",
      currency: "EUR"
    }
  end
end
