# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Voyager.Repo.insert!(%Voyager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Voyager.Accounts.Users

[
  %{
    name: "Andrey Marchenko",
    email: "altmer@mail.test",
    password: "12345678",
    password_confirmation: "12345678",
    avatar: "https://avatars3.githubusercontent.com/u/426400?s=460&v=4"
  },
  %{
    name: "John Doe",
    email: "johndoe@mail.test",
    password: "12345678",
    password_confirmation: "12345678",
    avatar: "https://avatars1.githubusercontent.com/u/2292577?s=460&v=4"
  }
]
|> Enum.map(&Users.add(&1))
