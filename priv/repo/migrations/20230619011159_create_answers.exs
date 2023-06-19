defmodule SpacedRep.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :text
      add :card_id, references(:cards, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create index(:answers, [:card_id])
  end
end
