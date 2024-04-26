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
end
