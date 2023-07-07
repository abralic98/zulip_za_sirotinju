defmodule Graphql.Types.Inputs.CreateAccountInput  do

  use Absinthe.Schema.Notation

  input_object :create_account_input do
    field(:email, non_null(:string))
    field(:username, non_null(:string))
    field(:password, non_null(:string))
  end
end
