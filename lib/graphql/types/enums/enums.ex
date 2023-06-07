defmodule Graphql.Types.Enums do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  enum :account_status do
    value(:online)
    value(:offline)
    value(:away)
    value(:busy)
  end


end
