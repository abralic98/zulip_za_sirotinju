defmodule Graphql.Types.Objects.ConversationReplyType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  node object(:conversation_reply) do
    field(:text, :string)
    field(:account, :account)
    field(:conversation, :conversation)
    field(:inserted_at, :datetime)
  end
end
