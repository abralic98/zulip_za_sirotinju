defmodule Schemas.Conversation do
  use Ecto.Schema
  alias Schemas.ConversationReply
  alias Schemas.Account

  import Ecto.Changeset

  @changeset ~w(user_one_id user_two_id)a

  schema "conversations" do
    belongs_to :user_one, Account
    belongs_to :user_two, Account
    has_many :conversation_replies, ConversationReply
    timestamps()
  end

  def changeset(room, args \\ %{}) do
    room
    |> cast(args, @changeset)
  end
end
