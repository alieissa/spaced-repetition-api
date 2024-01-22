defmodule SpacedRepWeb.DeckController do
  use SpacedRepWeb, :controller

  alias SpacedRep.Decks
  alias SpacedRep.Decks.Deck

  require Logger

  action_fallback SpacedRepWeb.FallbackController

  def index(conn, _params) do
    decks = Decks.list_decks()
    render(conn, :index, decks: decks)
  end

  def create(conn, deck_params) do
    with {:ok, %Deck{} = deck} <- Decks.create_deck(deck_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/decks/#{deck}")
      |> render(:show, deck: deck)
    end
  end

  def show(conn, %{"id" => id}) do
    deck = Decks.get_deck!(id)
    render(conn, :show, deck: deck)
  end

  def update(conn, %{"id" => id} = deck_params) do
    deck = Decks.get_deck!(id)

    with {:ok, %Deck{} = deck} <-
           Decks.update_deck(deck, deck_params) do
      render(conn, :show, deck: deck)
    end
  end

  def delete(conn, %{"id" => id}) do
    deck = Decks.get_deck!(id)

    with {:ok, %Deck{}} <- Decks.delete_deck(deck) do
      send_resp(conn, :no_content, "")
    end
  end
end
