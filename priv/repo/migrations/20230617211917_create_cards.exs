defmodule SpacedRep.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :quality, :integer, default: 3, null: false
      add :easiness, :float, default: 2.5, null: false
      add :interval, :integer, default: 1, null: false
      add :repetitions, :integer, default: 0, null: false
      add :question, :text, null: false
      # TODO Make default value next day
      add :next_practice_date, :naive_datetime
      add :deck_id, references(:decks, on_delete: :delete_all, type: :uuid), null: false

      timestamps()
    end

    create index(:cards, [:deck_id])
  end
end
