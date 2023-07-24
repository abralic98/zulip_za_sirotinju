defmodule Graphql.Types.Objects.AccountType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  # import_types(Graphql.Types.Enums.Enums.AccountStatus)

  node object(:account) do
    field(:email, :string)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:status, :account_status)
    field(:avatar, list_of(:avatar))
  end
end
