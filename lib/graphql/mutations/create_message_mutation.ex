defmodule Graphql.Mutations.CreateMessage do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Message

  def resolve(_, %{input: create_message_input}, %{context: %{current_user: current_user}}) do
    modified = Map.put(create_message_input, :account_id, Map.get(current_user, :id))

    {:ok, message} =
      %Message{}
      |> Message.changeset(modified)
      |> Repo.insert()

    Absinthe.Subscription.publish(ZulipZaSirotinjuWeb.Endpoint, message,
      get_messages_by_room_id: "Room:#{message.room_id}"
    )
    {:ok, message}
  end
end
