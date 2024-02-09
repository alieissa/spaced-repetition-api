defmodule SpacedRep.Repo.Migrations.AddUserId do
  use Ecto.Migration

  def change do
    alter table(:decks) do
      add :user_id, :uuid, null: false
    end
  end
end
