defmodule SpacedRepWeb.CardControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory
  alias SpacedRep.Cards.Card

  @create_attrs %{
    interval: 2,
    quality: 1,
    easiness: 1.3,
    question: "some question",
    answers: [%{content: "answer1"}],
    next_practice_date: ~U[2023-06-16 21:19:00Z]
  }
  @update_attrs %{
    interval: 2,
    quality: 1,
    easiness: 1.3,
    question: "some updated question",
    next_practice_date: ~U[2023-06-17 21:19:00Z]
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
      conn = get(conn, ~p"/decks/#{deck_id}/cards")

      assert json_response(conn, 200) == [
               %{
                 "id" => card.id,
                 "question" => card.question,
                 "answers" => [],
                 "deck_id" => card.deck_id,
                 "easiness" => card.easiness,
                 "interval" => card.interval,
                 "next_practice_date" => card.next_practice_date |> DateTime.to_iso8601(),
                 "quality" => card.quality,
                 "repetitions" => card.repetitions
               }
             ]
    end
  end

  describe "create card" do
    setup [:create_card]

    test "renders card when data is valid", %{
      conn: conn,
      card: %Card{deck_id: deck_id}
    } do
      conn = post(conn, ~p"/decks/#{deck_id}/cards", @create_attrs)

      assert(%{"id" => id} = json_response(conn, 201))

      conn = get(conn, ~p"/decks/#{deck_id}/cards/#{id}")

      %{easiness: easiness, interval: interval, question: question, quality: quality} =
        @create_attrs

      assert %{
               "id" => ^id,
               "easiness" => ^easiness,
               "interval" => ^interval,
               "next_practice_date" => "2023-06-16T21:19:00Z",
               "quality" => ^quality,
               "question" => ^question
               #  TODO add answers to assertion
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, card: %Card{deck_id: deck_id}} do
      conn = post(conn, ~p"/decks/#{deck_id}/cards", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update card" do
    setup [:create_card]

    test "renders card when data is valid", %{
      conn: conn,
      card: %Card{id: id, deck_id: deck_id} = card
    } do
      conn = put(conn, ~p"/decks/#{deck_id}/cards/#{id}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/decks/#{deck_id}/cards/#{card.id}")

      assert %{
               "id" => ^id,
               "easiness" => 1.3,
               "interval" => 2,
               "next_practice_date" => "2023-06-17T21:19:00Z",
               "quality" => 1,
               "question" => "some updated question"
             } = json_response(conn, 200)
    end

    # TODO Fix this test
    @tag :skip
    test "renders errors when data is invalid", %{
      conn: conn,
      card: %Card{id: id, deck_id: deck_id}
    } do
      conn = put(conn, ~p"/decks/#{deck_id}/cards/#{id}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete card" do
    setup [:create_card]

    test "deletes chosen card", %{conn: conn, card: %Card{id: id, deck_id: deck_id}} do
      conn = delete(conn, ~p"/decks/#{deck_id}/cards/#{id}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/decks/#{deck_id}/cards/#{id}")
      end)
    end
  end

  defp create_card(_) do
    card = insert(:card)
    %{card: card}
  end
end
