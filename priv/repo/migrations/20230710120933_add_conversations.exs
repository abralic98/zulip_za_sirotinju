defmodule ZulipZaSirotinju.Repo.Migrations.AddConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :user_one, :id
      add :user_two, :id
      timestamps()
    end
  end
end
