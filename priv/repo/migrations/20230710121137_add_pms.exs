defmodule ZulipZaSirotinju.Repo.Migrations.AddPms do
  use Ecto.Migration

  def change do
    create table(:conversation_replies) do
      add :text, :string, null: false
      add :account_id, references(:accounts, on_delete: :nothing), null: false
      add :conversation_id, references(:conversations, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
