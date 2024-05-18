defmodule SpacedRepWeb.UploadVerificationPlug do
  import Plug.Conn
  def init(opts), do: opts

  '''
  Expects the contents of a JSON file in plain text. Unfortunately, a way to
  a proper file from the upstream service, i.e. user management was not found.

  NOTE: Once a proper API Gateway is found, the upstream service will be retired
  '''

  def call(%Plug.Conn{request_path: "/decks/upload", params: params} = conn, _opts) do
    file = params["file"]

    with {:ok, raw_content} <- File.read(file.path),
         {:ok, decoded_content} <- Jason.decode(raw_content) do
      case validate_content(decoded_content) do
        {:ok, valid_content} -> assign(conn, :data, valid_content)
        {:error, _} -> send_resp(conn, 422, "Attempted to upload invalid data") |> halt()
      end
    end
  end

  def call(%Plug.Conn{request_path: "/decks/download"} = conn, _opts) do
    timestamp = System.os_time(:millisecond)
    s3_object_name = "decks-#{conn.assigns.user_id}-#{timestamp}.json"
    s3_path = "/#{s3_object_name}"
    s3_bucket = System.get_env("AWS_S3_BUCKET")

    conn |> assign(:s3_bucket, s3_bucket) |> assign(:s3_path, s3_path)
  end

  def call(conn, _opts) do
    conn
  end

  defp validate_content(content) do
    changesets = SpacedRepWeb.Decks.ImportedDeck.changeset_all(content)

    case changesets do
      {_, false} -> {:error, content}
      {_, true} -> {:ok, content}
    end
  end
end

defmodule SpacedRepWeb.Cards.ImportedCard do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :question, :string
    field :answers, {:array, :string}
  end

  def changeset(%{} = imported_card, attrs) do
    imported_card
    |> cast(attrs, [:question, :answers])
    |> validate_required([:question, :answers])
    |> validate_length(:answers, min: 1)
  end
end

defmodule SpacedRepWeb.Decks.ImportedDeck do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :description, :string
    embeds_many :cards, SpacedRepWeb.Cards.ImportedCard
  end

  def changeset(imported_deck, attrs \\ %{}) do
    imported_deck
    |> cast(attrs, [:name, :description])
    |> validate_required(:name)
    |> cast_embed(:cards, required: true)
  end

  def changeset_all(imported_decks) do
    map_reduce_cb = fn deck, acc ->
      chset = changeset(%__MODULE__{}, deck)
      {chset, chset.valid? && acc}
    end

    imported_decks
    |> Enum.map_reduce(true, fn deck, acc -> map_reduce_cb.(deck, acc) end)
  end
end
