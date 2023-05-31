defmodule Graphql.Queries.GetAccounts do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account

  def resolve(_,_,_) do
    response = Repo.all(Account)

    case response do
      [] ->
        {:error, "Eto sad si dobio svoje"}

      _ ->
        {:ok, response}
    end
  end
end
