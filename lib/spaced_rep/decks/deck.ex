defmodule SpacedRep.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [:id, :name, :description, :cards, :inserted_at, :updated_at, :deleted_at]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "decks" do
    field :name, :string
    field :description, :string
    field :user_id, :binary_id
    field :deleted_at, :utc_datetime
    has_many :cards, SpacedRep.Cards.Card

    timestamps()
  end

  def changeset(deck, %{deleted_at: _deleted_at} = attrs) do
    deck
    |> change(attrs)
    |> cast(attrs, [:deleted_at])
  end

  def changeset(deck, %{id: _id} = attrs) do
    deck
    |> change(attrs)
    |> unique_constraint(:name)
    |> cast_assoc(:cards)
  end

  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:description, :name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
    |> cast_assoc(:cards)
  end
end
