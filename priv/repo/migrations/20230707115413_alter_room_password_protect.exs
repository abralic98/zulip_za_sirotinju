defmodule ZulipZaSirotinju.Repo.Migrations.AlterRoomPasswordProtect do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add(:is_password_protected, :boolean, default: false)
    end
  end
end
