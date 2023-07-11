defmodule Graphql.Queries.GetUserConversations do
  alias Schemas.Conversation
  alias ZulipZaSirotinju.Repo
  import Ecto.Query

  def resolve(_, _, %{context: %{current_user: current_user}}) do
    query =
      from c in Conversation,
        where: c.user_one_id == ^current_user.id or c.user_two_id == ^current_user.id,
        join: u1 in assoc(c, :user_one),
        join: u2 in assoc(c, :user_two),
        select: %{c | user_one: u1, user_two: u2}

    case Repo.all(query) do
      nil ->
        {:error, "No Private Conversations found"}

      _ ->
        {:ok, Repo.all(query)}
    end
  end
end
