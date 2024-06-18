defmodule SpacedRep.Repo.Migrations.AddDeletedAtToAnswers do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :deleted_at, :utc_datetime, null: true
    end
  end
end
