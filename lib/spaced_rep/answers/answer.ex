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
    field :user_id, :binary_id
    field :deleted_at, :utc_datetime
    belongs_to :card, SpacedRep.Cards.Card

    timestamps()
  end

  @doc """
  Delete answer changeset
  """
  def changeset(answer, %{"deleted_at" => _deleted_at} = attrs) do
    answer |> cast(attrs, [:deleted_at])
  end

  @doc """
  Update answer changeset
  """
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
