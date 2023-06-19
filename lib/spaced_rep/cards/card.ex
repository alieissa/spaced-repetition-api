defmodule SpacedRep.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "cards" do
    field :interval, :integer, default: 1
    field :quality, :integer, default: 3
    field :easiness, :float, default: 2.5
    field :repetitions, :integer, default: 0
    field :question, :string

    field :next_practice_date, :naive_datetime

    has_many :answer, SpacedRep.Answers.Answer
    belongs_to :deck, SpacedRep.Decks.Deck

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [
      :deck_id,
      :quality,
      :easiness,
      :interval,
      :question,
      :repetitions,
      :next_practice_date
    ])
    |> validate_required([:interval, :question])
    |> validate_number(:easiness, greater_than_or_equal_to: 1.3)
    |> validate_number(:quality, greater_than: 0, less_than_or_equal_to: 5)
    |> unique_constraint(:question)
  end
end
