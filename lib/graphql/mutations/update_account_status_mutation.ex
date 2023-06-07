defmodule Graphql.Mutations.UpdateAccountStatus do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account

  def resolve(_, %{status: enum}, %{context: %{current_user: current_user}}) do
    Repo.get(Account, current_user.id)
    |> Account.changeset(%{status: enum})
    |> Repo.update()
  end
end
