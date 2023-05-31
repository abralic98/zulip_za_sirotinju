

defmodule Graphql.Types.Objects.MessageType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern


  object(:message) do
    field(:text, :string)
    field(:account, :account)
    field(:room, :room)
  end
end
