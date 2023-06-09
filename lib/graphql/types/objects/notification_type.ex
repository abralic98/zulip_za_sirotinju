defmodule Graphql.Types.Objects.NotificationType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object(:notification) do
    field(:id, :id)
    field(:account, :account)
    field(:room, :room)
    field(:message, :message)
    field(:inserted_at, :datetime)
  end
end
