defmodule SpacedRepWeb.CardControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory
  alias SpacedRep.Cards.Card

  @create_attrs %{
    interval: 2,
    quality: 1,
    easiness: 1.3,
    question: "some question",
    next_practice_date: ~N[2023-06-16 21:19:00]
  }
  @update_attrs %{
    interval: 2,
    quality: 1,
    easiness: 1.3,
    question: "some updated question",
    next_practice_date: ~N[2023-06-17 21:19:00]
  }
  @invalid_attrs %{
    interval: nil,
    quality: nil,
    easiness: 1,
    question: nil,
    next_practice_date: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_card]

    test "lists all cards", %{conn: conn, card: %Card{deck_id: deck_id} = card} do
      conn = get(conn, ~p"/api/decks/#{deck_id}/cards")

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => card.id,
                 "deck_id" => card.deck_id,
                 "easiness" => card.easiness,
                 "interval" => card.interval,
                 "next_practice_date" => card.next_practice_date |> NaiveDateTime.to_iso8601(),
                 "quality" => card.quality,
                 "question" => card.question,
                 "repetitions" => card.repetitions
               }
             ]
    end
  end

  describe "create card" do
    setup [:create_card]

    test "renders card when data is valid", %{conn: conn, card: %Card{deck_id: deck_id}} do
      conn =
        post(conn, ~p"/api/decks/#{deck_id}/cards", Map.merge(@create_attrs, %{deck_id: deck_id}))

      assert(%{"id" => id} = json_response(conn, 201)["data"])

      conn = get(conn, ~p"/api/decks/#{deck_id}/cards/#{id}")

      assert %{
               "id" => ^id,
               "easiness" => 1.3,
               "interval" => 2,
               "next_practice_date" => "2023-06-16T21:19:00",
               "quality" => 1,
               "question" => "some question"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, card: %Card{deck_id: deck_id}} do
      conn = post(conn, ~p"/api/decks/#{deck_id}/cards", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update card" do
    setup [:create_card]

    test "renders card when data is valid", %{
      conn: conn,
      card: %Card{id: id, deck_id: deck_id} = card
    } do
      conn = put(conn, ~p"/api/decks/#{deck_id}/cards/#{card}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/decks/#{deck_id}/cards/#{id}")

      assert %{
               "id" => ^id,
               "easiness" => 1.3,
               "interval" => 2,
               "next_practice_date" => "2023-06-17T21:19:00",
               "quality" => 1,
               "question" => "some updated question"
             } = json_response(conn, 200)["data"]
    end

    # TODO Fix this test
    @tag :skip
    test "renders errors when data is invalid", %{
      conn: conn,
      card: %Card{id: id, deck_id: deck_id}
    } do
      conn = put(conn, ~p"/api/decks/#{deck_id}/cards/#{id}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete card" do
    setup [:create_card]

    test "deletes chosen card", %{conn: conn, card: %Card{id: id, deck_id: deck_id}} do
      conn = delete(conn, ~p"/api/decks/#{deck_id}/cards/#{id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/decks/#{deck_id}/cards/#{id}")
      end
    end
  end

  defp create_card(_) do
    card = insert(:card)
    %{card: card}
  end
end
