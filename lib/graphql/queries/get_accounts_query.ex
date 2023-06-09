defmodule Graphql.Queries.GetAccounts do
  import Ecto.Query
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account

  def resolve(_, _, _) do
    response = Repo.all(Account)

    case response do
      [] ->
        {:error, "Eto sad si dobio svoje"}

      _ ->
        {:ok, response}
    end
  end

  def resolve_subscription(_, _, _) do
    query =
      from(a in Account,
        order_by: [
          fragment(
            "CASE WHEN status = 'online' THEN 1 WHEN status = 'away' THEN 2 WHEN status = 'busy' THEN 3 ELSE 4 END"
          ),
          a.username
        ],
        select: a
      )

    {:ok, Repo.all(query)}
  end
end
