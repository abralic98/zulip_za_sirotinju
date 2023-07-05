
defmodule Graphql.Types.Inputs.CreateFileInput do
  use Absinthe.Schema.Notation

  input_object :create_file_input do
    field(:file_name, :string)
    field(:file_path, :string)
  end
end
