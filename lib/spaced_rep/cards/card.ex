defmodule SpacedRep.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias SpacedRep.Answers.Answer
  alias SpacedRep.Decks.Deck

  @derive {Jason.Encoder,
           only: [:id, :question, :answers, :inserted_at, :updated_at, :deleted_at]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "cards" do
    field(:interval, :integer, default: 1)
    field(:quality, :integer, default: 3)
    field(:easiness, :float, default: 2.5)
    field(:repetitions, :integer, default: 0)
    field(:question, :string)
    field(:user_id, :binary_id)

    field(:next_practice_date, :utc_datetime)
    field :deleted_at, :utc_datetime
    has_many :answers, Answer, defaults: :set_user_id
    belongs_to :deck, Deck

    timestamps()
  end

  def set_user_id(%Answer{} = answer, %__MODUE__{} = card) do
    %{answer | user_id: card.user_id}
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
      :next_practice_date,
      :user_id
    ])
    |> validate_required([:interval, :question])
    |> validate_number(:easiness, greater_than_or_equal_to: 1.3)
    |> validate_number(:quality, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> unique_constraint(:question)
    |> cast_assoc(:answers)
  end

  @doc """
  Delete card changeset
  """
  def changeset(card, %{"deleted_at" => _deleted_at} = attrs) do
    card
    |> cast(attrs, [:deleted_at])
  end

  @doc """
  Update card changeset
  """
  def changeset(card, %{"user_id" => _user_id, "deck_id" => _deck_id} = attrs) do
    card
    |> cast(attrs, [
      :quality,
      :easiness,
      :interval,
      :question,
      :repetitions,
      :next_practice_date,
      :user_id,
      :deck_id
    ])
    |> validate_required([:interval, :question, :deck_id, :user_id])
    |> validate_number(:easiness, greater_than_or_equal_to: 1.3)
    |> validate_number(:quality, greater_than: 0, less_than_or_equal_to: 5)
    |> unique_constraint(:question)
    |> cast_assoc(:answers)
  end

  @doc """
  Create card changeset
  """
  def changeset(card, attrs) do
    card
    |> cast(attrs, [
      :deck_id,
      :quality,
      :easiness,
      :interval,
      :question,
      :repetitions,
      :next_practice_date,
      :user_id
    ])
    |> validate_required([:interval, :question])
    |> validate_number(:easiness, greater_than_or_equal_to: 1.3)
    |> validate_number(:quality, greater_than: 0, less_than_or_equal_to: 5)
    |> unique_constraint(:question)
    |> cast_assoc(:answers)
  end
end
