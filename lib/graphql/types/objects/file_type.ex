defmodule Graphql.Types.Objects.FileType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  object(:avatar) do
    field(:file_name, :string)
    field(:file_path, :string)
    field(:inserted_at, :datetime)
  end
end
