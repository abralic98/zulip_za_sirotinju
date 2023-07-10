defmodule Schemas.ConversationReply do

  use Ecto.Schema
  import Ecto.Changeset
  alias Schemas.Account
  alias Schemas.Conversation

  @changeset ~w(text conversation_id account_id)a

  schema "messages" do
    field(:text, :string)
    belongs_to :account, Account
    belongs_to :conversation,
    timestamps()
  end

  def changeset(message, args \\ %{}) do
    message
    |> cast(args, @changeset)
  end
end
