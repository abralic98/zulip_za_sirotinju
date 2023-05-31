defmodule :"Elixir.ZulipZaSirotinju.Repo.Migrations.Add-messages" do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string, null: false
      add :account_id, references(:accounts, on_delete: :nothing), null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false
    end
  end
end
