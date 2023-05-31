defmodule Schemas.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Schemas.Account
  alias Schemas.Room

  @changeset ~w(text room_id account_id)a

  schema "messages" do
    field(:text, :string)
    belongs_to :account, Account
    belongs_to :room, Room
    timestamps()
  end

  def changeset(message, args \\ %{}) do
    message
    |> cast(args, @changeset)
  end
end
