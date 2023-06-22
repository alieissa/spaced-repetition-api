defmodule SpacedRep.Answers.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "answers" do
    field :content, :string
    belongs_to :card, SpacedRep.Cards.Card

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
