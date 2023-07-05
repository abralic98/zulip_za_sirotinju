defmodule ZulipZaSirotinju.Repo.Migrations.AddAvatar do
  use Ecto.Migration


  def change do
    create table(:avatars) do
      add :file_name, :string, null: false
      add :file_path, :string, null: false
      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
