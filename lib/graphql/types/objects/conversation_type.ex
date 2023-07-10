defmodule Graphql.Types.Objects.ConversationType do

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object(:conversation) do
    field(:id, :id)
    field(:user_one, :id)
    field(:user_two, :id)
  end
end
