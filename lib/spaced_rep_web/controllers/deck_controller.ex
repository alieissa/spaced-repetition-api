defmodule SpacedRepWeb.DeckController do
  use SpacedRepWeb, :controller

  alias SpacedRep.Decks
  alias SpacedRep.Decks.Deck

  action_fallback SpacedRepWeb.FallbackController

  def index(conn, _params) do
    decks = Decks.list_decks()
    render(conn, :index, decks: decks)
  end

  def create(conn, deck_params) do
    with {:ok, %Deck{} = deck} <- Decks.create_deck(conn.assigns.user_id, deck_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/decks/#{deck}")
      |> render(:show, deck: deck)
    end
  end

  def show(conn, %{"id" => id}) do
    with %Deck{} = deck <- Decks.get_deck(id) do
      render(conn, :show, deck: deck)
    end
  end

  def update(conn, %{"id" => id} = deck_params) do
    with %Deck{} = deck <- Decks.get_deck(id),
         {:ok, %Deck{} = deck} <-
           Decks.update_deck(deck, deck_params) do
      render(conn, :show, deck: deck)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Deck{}} <- Decks.delete_deck(id) do
      conn
      |> resp(:no_content, "")
      |> send_resp()
    end
  end

  def upload(conn, _opts) do
    case Decks.upload_decks(conn.assigns.data, conn.assigns.user_id) do
      {:ok, _} -> send_resp(conn, :created, "")
      {:error, _} -> send_resp(conn, :unprocessable_entity, "")
    end
  end

  def download(conn, _opts) do
    with decks when is_list(decks) <- Decks.list_decks(),
         {:ok, content} <- Jason.encode(decks),
         {:ok, _} <- s3_put_object(conn, content),
         {:ok, url} <- s3_get_presigned_url(conn) do
      send_resp(conn, :ok, url)
    end
  end

  defp s3_put_object(conn, content) do
    ExAws.S3.put_object(conn.assigns.s3_bucket, conn.assigns.s3_path, content, [
      {:content_type, "application/json"}
    ])
    |> ExAws.request()
  end

  defp s3_get_presigned_url(conn) do
    opts = [
      expires_in: 3600,
      # The query params are crucial. They make the pre-signed url a url that the
      # browser treats as download link
      query_params: [{"response-content-disposition", "attachment; filename=decks.json"}]
    ]

    ExAws.Config.new(:s3, [])
    |> ExAws.S3.presigned_url(:get, conn.assigns.s3_bucket, conn.assigns.s3_path, opts)
  end
end
