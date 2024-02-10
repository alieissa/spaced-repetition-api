defmodule SpacedRep.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :question, :answers]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "cards" do
    field(:interval, :integer, default: 1)
    field(:quality, :integer, default: 3)
    field(:easiness, :float, default: 2.5)
    field(:repetitions, :integer, default: 0)
    field(:question, :string)

    field(:next_practice_date, :utc_datetime)
    field :deleted_at, :utc_datetime
    has_many :answers, SpacedRep.Answers.Answer
    belongs_to :deck, SpacedRep.Decks.Deck

    timestamps()
  end

  @doc false
  def changeset(card, deck_id, attrs) do
    card
    |> change(%{deck_id: deck_id})
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
    |> cast_assoc(:answers)
  end

  def changeset(card, %{deleted_at: _deleted_at} = attrs) do
    card
    |> change(attrs)
    |> cast(attrs, [:deleted_at])
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [
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
    |> cast_assoc(:answers)
  end
end
