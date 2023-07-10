defmodule Schemas.Conversation do
  use Ecto.Schema
  alias Schemas.ConversationReply

  import Ecto.Changeset

  @changeset ~w(user_one user_two)a

  schema "conversations" do
    field :user_one, :id
    field :user_two, :id
    has_many :conversation_replies, ConversationReply
    timestamps()
  end

  def changeset(room, args \\ %{}) do
    room
    |> cast(args, @changeset)
  end
end
