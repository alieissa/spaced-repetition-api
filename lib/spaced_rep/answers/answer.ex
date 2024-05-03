defmodule SpacedRep.Answers.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :content, :inserted_at, :updated_at]}

  # TODO Add deleted_at nullable deleted_at field to schema
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
