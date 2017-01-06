# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Graphql.Repo.insert!(%Graphql.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Graphql.User
alias Graphql.Post
alias Graphql.Repo

Repo.insert!(%User{name: "Michael Niepel", email: "michael.niepel@gmail.com"})
Repo.insert!(%User{name: "John Doe", email: "john.doe@gmail.com"})

for _ <- 1..10 do
  Repo.insert!(%Post{
      title: Faker.Lorem.sentence,
      body: Faker.Lorem.paragraph,
      user_id: [1, 2] |> Enum.take_random(1) |> hd
    })
end