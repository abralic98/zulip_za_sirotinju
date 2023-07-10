defmodule Graphql.Queries.GetUserConversations do
  alias Schemas.Conversation
  alias ZulipZaSirotinju.Repo
  import Ecto.Query

  def resolve(_, _, %{context: %{current_user: current_user}}) do
    query =
      from c in Conversation,
        where: c.user_one == ^current_user.id or c.user_two == ^current_user.id

    case Repo.all(query) do
      nil ->
        {:error, "No Private Conversations found"}

      conversation ->
        {:ok, "ok"}

        {:ok, Repo.all(query)}
    end
  end
end
