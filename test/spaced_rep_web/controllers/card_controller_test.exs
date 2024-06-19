defmodule SpacedRepWeb.CardControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory
  alias SpacedRep.TestUtils, as: Utils

  @user_id Ecto.UUID.generate()

  setup %{conn: conn} do
    token = Utils.get_token(%{"sub" => @user_id})

    conn =
      conn
      |> put_req_header("authorization", "bearer #{token}")
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all cards", %{conn: conn} do
      card = insert(:card, %{user_id: @user_id})
      conn = get(conn, ~p"/decks/#{card.deck_id}/cards")

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

  describe "POST /cards" do
    test "when input data is valid", %{
      conn: conn
    } do
      deck = setup_deck()

      valid_data = %{
        "interval" => 2,
        "quality" => 1,
        "easiness" => 1.3,
        "question" => "some question",
        # TODO re-introduce after custom body parser is written
        # "answers" => [%{"content" => "answer1"}]
        "answers" => []
      }

      conn = post_card(conn, deck.id, valid_data)

      resp = json_response(conn, 201)
      assert resp["easiness"] == valid_data["easiness"]
      assert resp["interval"] == valid_data["interval"]
      assert resp["quality"] == valid_data["quality"]
      assert resp["question"] == valid_data["question"]
    end

    test "when input data is invalid", %{conn: conn} do
      deck = setup_deck()

      invalid_data = %{
        question: nil
      }

      conn =
        post_card(
          conn,
          deck.id,
          invalid_data
        )

      resp = json_response(conn, 422)
      assert resp["errors"]
    end
  end

  describe "PUT /cards/:id" do
    test "when input data is valid", %{
      conn: conn
    } do
      card = setup_card()

      valid_data = %{
        "interval" => 2,
        "quality" => 1,
        "easiness" => 1.3,
        "question" => "some updated question"
      }

      conn = put_card(conn, %{"id" => card.id, "deck_id" => card.deck_id}, valid_data)

      resp = json_response(conn, 200)

      assert resp["easiness"] == valid_data["easiness"]
      assert resp["interval"] == valid_data["interval"]
      assert resp["quality"] == valid_data["quality"]
      assert resp["question"] == valid_data["question"]
    end

    # TODO Fix this test

    test "when input data is invalid", %{
      conn: conn
    } do
      card = setup_card()

      invalid_data = %{question: nil}

      conn = put_card(conn, %{"id" => card.id, "deck_id" => card.deck_id}, invalid_data)

      resp = json_response(conn, 422)
      assert resp["errors"]
    end
  end

  test "DELETE /cards/:id", %{conn: conn} do
    card = setup_card()

    conn = delete_card(conn, %{"id" => card.id, "deck_id" => card.deck_id})

    assert response(conn, 204)
  end

  defp setup_deck() do
    insert(:deck, %{user_id: @user_id})
  end

  defp setup_card() do
    insert(:card, %{user_id: @user_id})
  end

  defp post_card(conn, deck_id, data) do
    post(conn, ~p"/decks/#{deck_id}/cards", data)
  end

  defp put_card(conn, %{"id" => id, "deck_id" => deck_id}, data) do
    put(conn, ~p"/decks/#{deck_id}/cards/#{id}", data)
  end

  defp delete_card(conn, %{"id" => id, "deck_id" => deck_id}) do
    delete(conn, ~p"/decks/#{deck_id}/cards/#{id}")
  end
end
