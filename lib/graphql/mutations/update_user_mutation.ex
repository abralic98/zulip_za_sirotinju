defmodule Graphql.Mutations.UpdateUser do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account
  def resolve(_, %{input: update_user_input}, %{context: %{current_user: current_user}}) do

    Repo.get(Account, current_user.id)
    |> Account.changeset_update_account(update_user_input)
    |> Repo.update()
  end

end
