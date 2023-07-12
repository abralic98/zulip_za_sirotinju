
defmodule Schemas.PrivateNotification do
  use Ecto.Schema

  import Ecto.Changeset
  alias Schemas.ConversationReply
  alias Schemas.Conversation
  alias Schemas.Account

  @changeset ~w(conversation_id account_id conversation_reply_id)a

  schema "private_notifications" do
    belongs_to :conversation_reply, ConversationReply
    belongs_to :conversation, Conversation
    belongs_to :account, Account
    timestamps()
  end

  def changeset(notification, args \\ %{}) do
    notification
    |> cast(args, @changeset)
  end
end
