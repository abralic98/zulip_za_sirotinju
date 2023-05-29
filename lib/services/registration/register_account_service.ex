defmodule Services.Registration.RegisterAccountService do
  alias ZulipZaSirotinju.Repo
  alias Schemas.Account
  alias ZulipZaSirotinju.Mailer

  def execute(_root, %{input: input}, _context) do
    IO.inspect(input)
    %Account{}
    |> Account.changeset(input)
    |> ZulipZaSirotinju.Mailer.send_welcome_text_email(input.email)
    # |> Repo.insert()
  end


end
