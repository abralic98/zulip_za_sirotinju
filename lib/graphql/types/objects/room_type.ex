defmodule Graphql.Types.Objects.RoomType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object(:room) do
    field(:id, :id)
    field(:name, :string)
    field(:is_password_protected, :boolean)
  end
end
