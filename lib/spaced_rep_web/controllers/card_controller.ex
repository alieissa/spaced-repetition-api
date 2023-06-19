defmodule SpacedRepWeb.CardController do
  use SpacedRepWeb, :controller

  alias SpacedRep.Cards
  alias SpacedRep.Cards.Card

  action_fallback SpacedRepWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.path_params, conn.body_params]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"deck_id" => deck_id}, _) do
    cards = Cards.list_cards(deck_id)
    render(conn, :index, cards: cards)
  end

  def create(conn, %{"deck_id" => deck_id}, card_params) do
    with {:ok, %Card{} = card} <- Cards.create_card(card_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/decks/#{deck_id}/cards/#{card}")
      |> render(:show, card: card)
    end
  end

  def show(conn, %{"id" => id}, _) do
    card = Cards.get_card!(id)
    render(conn, :show, card: card)
  end

  def update(conn, %{"id" => id}, card_params) do
    card = Cards.get_card!(id)

    with {:ok, %Card{} = card} <- Cards.update_card(card, card_params) do
      render(conn, :show, card: card)
    end
  end

  def delete(conn, %{"id" => id}, _) do
    card = Cards.get_card!(id)

    with {:ok, %Card{}} <- Cards.delete_card(card) do
      send_resp(conn, :no_content, "")
    end
  end
end
