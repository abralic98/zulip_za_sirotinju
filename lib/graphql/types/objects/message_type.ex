defmodule Graphql.Types.Objects.MessageType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  node object(:message) do
    field(:text, :string)
    field(:account, :account)
    field(:room, :room)
    field(:inserted_at, :datetime)
  end
end
