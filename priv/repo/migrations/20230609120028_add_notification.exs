defmodule ZulipZaSirotinju.Repo.Migrations.AddNotification do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :messages, references(:messages, on_delete: :delete_all), null: false
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
