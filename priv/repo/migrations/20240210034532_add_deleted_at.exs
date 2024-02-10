defmodule SpacedRep.Repo.Migrations.AddDeletedAt do
  use Ecto.Migration

  def change do
    alter table(:decks) do
      add :deleted_at, :utc_datetime, null: true
    end

    alter table(:cards) do
      add :deleted_at, :utc_datetime, null: true
    end
  end
end
