defmodule ZulipZaSirotinju.Repo.Migrations.PrivateNotifications do
  use Ecto.Migration

  def change do

    create table(:private_notifications) do
      add :conversation_reply_id, references(:conversation_replies, on_delete: :delete_all), null: false
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      add :conversation_id, references(:conversations, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
