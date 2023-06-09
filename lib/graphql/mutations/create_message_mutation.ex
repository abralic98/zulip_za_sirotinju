defmodule Graphql.Mutations.CreateMessage do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message
  alias Schemas.Notification

  def resolve(_, %{input: create_message_input}, %{context: %{current_user: current_user}}) do
    modified = Map.put(create_message_input, :account_id, Map.get(current_user, :id))

    {:ok, message} =
      %Message{}
      |> Message.changeset(modified)
      |> Repo.insert()

    {:ok, notification} =
      resolve_notification(%{
        account_id: current_user.id,
        room_id: modified.room_id,
        message_id: message.id
      })

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, message,
      get_messages_by_room_id_socket: "Room:#{message.room_id}"
    )

    # {:ok, %{message: message, notification: notification}}
    {:ok, message}
  end

  defp resolve_notification(args) do
    {:ok, notification} =
      %Notification{}
      |> Notification.changeset(args)
      |> Repo.insert()

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, notification,
      notifications: "Notifications"
    )

    {:ok, notification}
  end
end
