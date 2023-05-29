# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ZulipZaSirotinju.Repo.insert!(%ZulipZaSirotinju.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ZulipZaSirotinju.Repo
alias Schemas.Account

%Account{}
|> Account.changeset(%{
  first_name: "Kodius",
  last_name: "Test",
  password: "Ruda,actv1!",
  username: "kodius_test",
  email: "user@kodius.com"
})
|> Repo.insert()
