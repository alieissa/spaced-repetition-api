defmodule SpacedRep.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "decks" do
    field :name, :string
    field :description, :string
    has_many :card, SpacedRep.Cards.Card

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
  end
end
