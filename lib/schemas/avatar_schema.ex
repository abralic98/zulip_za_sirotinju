
defmodule Schemas.Avatar do
  use Ecto.Schema
  import Ecto.Changeset
  alias Schemas.Account

  @changeset ~w(file_name file_path account_id)a

  schema "avatars" do
    field(:file_name, :string)
    field(:file_path, :string)
    belongs_to :account, Account
    timestamps()
  end

  def changeset(avatar, args \\ %{}) do
    avatar
    |> cast(args, @changeset)
  end
end
