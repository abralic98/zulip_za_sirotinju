defmodule Services.Registration.RegisterAccountService do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account

  def execute(_root, %{input: input}, _context) do
    %Account{}
    |> Account.changeset(input)
    |> Repo.insert()
  end


end
