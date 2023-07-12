
defmodule Graphql.Types.Objects.PrivateNotificationType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object(:private_notification) do
    field(:id, :id)
    field(:account, :account)
    field(:conversation, :conversation)
    field(:conversation_reply, :conversation_reply)
    field(:inserted_at, :datetime)
  end
end
