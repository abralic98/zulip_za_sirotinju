
defmodule Graphql.Types.Inputs.CreateConversationReplyInput do
  use Absinthe.Schema.Notation

  input_object :create_conversation_reply_input do
    field(:text, :string)
    field(:conversation_id, :string)
  end
end
