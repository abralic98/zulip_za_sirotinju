defmodule Graphql.Mutations.CreateConversationReply do
  alias ZulipZaSirotinju.Repo
  alias Schemas.ConversationReply
  alias Schemas.PrivateNotification

  def resolve(_, %{input: create_conversation_reply_input}, %{
        context: %{current_user: current_user}
      }) do
    modified = Map.put(create_conversation_reply_input, :account_id, Map.get(current_user, :id))

    {:ok, conversation_reply} =
      %ConversationReply{} |> ConversationReply.changeset(modified) |> Repo.insert()

    {:ok, private_notification} =
      resolve_notification(%{
        account_id: current_user.id,
        conversation_id: modified.conversation_id,
        conversation_reply_id: conversation_reply.id
      })

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, conversation_reply,
      get_conversation_replies_by_conversation_id_socket: "Conversation:#{conversation_reply.conversation_id}"
    )

    {:ok, conversation_reply}
  end

  defp resolve_notification(args) do
    {:ok, private_notification} =
      %PrivateNotification{}
      |> PrivateNotification.changeset(args)
      |> Repo.insert()

      IO.inspect(args.account_id, label: "RESOLVE NOTIFI ARGS")
      #problem

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, private_notification,
      private_notifications: "PrivateNotifications: #{args.account_id}"
    )
    {:ok, private_notification}
  end
end
