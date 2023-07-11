defmodule Graphql.Mutations.CreateConversationReply do
  alias ZulipZaSirotinju.Repo
  alias Schemas.ConversationReply

  def resolve(_, %{input: create_conversation_reply_input}, %{
        context: %{current_user: current_user}
      }) do

    modified = Map.put(create_conversation_reply_input, :account_id, Map.get(current_user, :id))

    {:ok, _} = %ConversationReply{} |> ConversationReply.changeset(modified) |> Repo.insert()
  end
end
