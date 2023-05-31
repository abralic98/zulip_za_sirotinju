defmodule Graphql.Types.Inputs.CreateMessageInput do
  use Absinthe.Schema.Notation

  input_object :create_message_input do
    field(:text, :string)
    field(:room_id, :string)
  end
end
