defmodule ZulipZaSirotinju.Repo.Migrations.AddRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false
      add :password, :string, null: true

      timestamps()
    end
  end
end
