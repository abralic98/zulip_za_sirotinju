defmodule ZulipZaSirotinju.Repo.Migrations.AddConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :user_one_id, references(:accounts, on_delete: :delete_all), null: false
      add :user_two_id, references(:accounts, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
