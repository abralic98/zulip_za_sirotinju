defmodule Graphql.Mutations.CreateAccount do
  alias Services.Registration.RegisterAccountService

  def resolve(_root, %{input: input}, _context) do
    RegisterAccountService.execute(_root, %{input: input}, _context)
  end
end
