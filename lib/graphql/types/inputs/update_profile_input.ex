
defmodule Graphql.Types.Inputs.UpdateProfileInput  do

  use Absinthe.Schema.Notation

  input_object :update_profile_input do
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
  end
end
