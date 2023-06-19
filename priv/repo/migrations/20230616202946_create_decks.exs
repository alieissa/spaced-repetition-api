defmodule SpacedRep.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :description, :text, null: true
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:decks, [:name])
  end
end
