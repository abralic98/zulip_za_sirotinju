
defmodule Graphql.Types.Inputs.CreateRoomInput do
  use Absinthe.Schema.Notation

  input_object :create_room_input do
    field(:name, non_null(:string))
    field(:password, :string)
  end
end
