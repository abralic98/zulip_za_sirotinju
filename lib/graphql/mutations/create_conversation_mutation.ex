defmodule Graphql.Mutations.CreateConversation do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Conversation
  import Ecto.Query

  def resolve(_, %{user_two: user_two}, %{context: %{current_user: current_user}}) do
    input = %{user_two_id: user_two, user_one_id: current_user.id}

    conversation_exists =
      from c in Conversation,
        where:
          (c.user_one_id == ^current_user.id and c.user_two_id == ^user_two) or
            (c.user_one_id == ^user_two and c.user_two_id == ^current_user.id)

    case Repo.all(conversation_exists) do
      [] ->
        {:ok, _} = %Conversation{} |> Conversation.changeset(input) |> Repo.insert()

      _ ->
        {:error, "Conversation already exists"}
    end
  end
end
