defmodule ZulipZaSirotinju.Repo.Migrations.TypoNotification do
  use Ecto.Migration

  def change do
    rename table(:notifications), :messages, to: :message_id
  end
end
