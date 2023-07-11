defmodule Graphql.Mutations.CreateConversationReply do
  alias ZulipZaSirotinju.Repo
  alias Schemas.ConversationReply

  def resolve(_, %{input: create_conversation_reply_input}, %{
        context: %{current_user: current_user}
      }) do
    modified = Map.put(create_conversation_reply_input, :account_id, Map.get(current_user, :id))

    {:ok, conversation_reply} =
      %ConversationReply{} |> ConversationReply.changeset(modified) |> Repo.insert()

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, conversation_reply,
      get_conversation_replies_by_conversation_id: "Conversation:#{conversation_reply.conversation_id}"
    )

    {:ok, conversation_reply}
  end
end
