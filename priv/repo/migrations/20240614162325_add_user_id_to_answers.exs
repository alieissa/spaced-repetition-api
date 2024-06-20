defmodule SpacedRep.Repo.Migrations.AddUserIdToAnswers do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :user_id, :uuid, null: false
    end
  end
end
