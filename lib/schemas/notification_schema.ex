defmodule Schemas.Notification do
  use Ecto.Schema

  import Ecto.Changeset
  alias Schemas.Message
  alias Schemas.Room
  alias Schemas.Account

  @changeset ~w(room_id account_id message_id)a

  schema "notifications" do
    belongs_to :message, Message
    belongs_to :room, Room
    belongs_to :account, Account
    timestamps()
  end

  def changeset(notification, args \\ %{}) do
    notification
    |> cast(args, @changeset)
  end
end
