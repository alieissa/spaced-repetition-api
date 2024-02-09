defmodule SpacedRep.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "decks" do
    field :name, :string
    field :description, :string
    field :user_id, :binary_id
    has_many :cards, SpacedRep.Cards.Card

    timestamps()
  end

  @doc false
  def changeset(deck, user_id, attrs) do
    deck
    |> change(%{user_id: user_id})
    |> cast(attrs, [:description, :name, :user_id])
    |> validate_required([:description, :name])
    |> cast_assoc(:cards)
  end

  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
    |> cast_assoc(:cards)
  end
end
