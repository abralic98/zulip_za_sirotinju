defmodule Services.Registration.RegisterAccountService do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account

  def execute(_root, %{input: input}, _context) do
    IO.inspect(input)
    %Account{}
    |> Account.changeset(input)
    |> Repo.insert()
  end


end
