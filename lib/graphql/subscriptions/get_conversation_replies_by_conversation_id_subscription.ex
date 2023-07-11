defmodule Graphql.Subscriptions.GetConversationRepliesByConversationIdSubscription do
  alias ZulipZaSirotinju.Repo
  alias Schemas.ConversationReply

  def resolve(conversation_reply, _, _) do
    response =
      Repo.get(ConversationReply, conversation_reply.id)
      |> Repo.preload(:account)
      |> Repo.preload(:conversation)

    {:ok, response}
  end
end
