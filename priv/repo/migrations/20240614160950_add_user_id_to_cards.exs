defmodule SpacedRep.Repo.Migrations.AddUserIdToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :user_id, :uuid, null: false
    end
  end
end
