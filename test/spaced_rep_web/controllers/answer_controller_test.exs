defmodule SpacedRepWeb.AnswerControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory
  alias SpacedRep.Answers.Answer

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
    test "lists all answers", %{conn: conn} do
      answer = setup_answer()

      conn = get(conn, ~p"/decks/#{answer.card.deck_id}/cards/#{answer.card_id}/answers")

      resp = json_response(conn, 200)

      assert resp == [%{"id" => answer.id, "content" => answer.content}]
    end
  end

  describe "POST /answers" do
    test "when input data is valid", %{conn: conn} do
      card = setup_card()

      data = %{"content" => "How are you?"}
      conn = post_answer(conn, %{"deck_id" => card.deck_id, "card_id" => card.id}, data)

      resp = json_response(conn, 201)
      assert resp["content"] == data["content"]
    end

    test "when input data is invalid", %{conn: conn} do
      card = setup_card()

      conn =
        post_answer(conn, %{"deck_id" => card.deck_id, "card_id" => card.id}, %{"content" => nil})

      resp = json_response(conn, 422)
      assert resp["errors"]
    end
  end

  describe "PUT /answers/:id" do
    test "when input data is valid", %{conn: conn} do
      answer = setup_answer()

      data = %{
        "content" => "some updated content"
      }

      conn =
        put_answer(
          conn,
          %{
            "id" => answer.id,
            "card_id" => answer.card_id,
            "deck_id" => answer.card.deck_id
          },
          data
        )

      resp = json_response(conn, 200)
      assert resp == %{"id" => answer.id, "content" => data["content"]}
    end

    test "when input data is invalid", %{conn: conn} do
      answer = setup_answer()

      invalid_data = %{
        "content" => nil
      }

      conn =
        put_answer(
          conn,
          %{
            "id" => answer.id,
            "card_id" => answer.card_id,
            "deck_id" => answer.card.deck_id
          },
          invalid_data
        )

      resp = json_response(conn, 422)
      assert resp["errors"]
    end
  end

  test "DELETE /answers/:id", %{conn: conn} do
    answer = setup_answer()

    conn =
      delete_answer(conn, %{
        "id" => answer.id,
        "card_id" => answer.card_id,
        "deck_id" => answer.card.deck_id
      })

    assert response(conn, 204)
  end

  describe "POST /answers/check" do
    test "nearest answer to user input", %{conn: conn} do
      answer = setup_answer(%{content: "test 123"})

      user_input = %{"answer" => "test"}

      conn =
        check_answer(
          conn,
          %{"deck_id" => answer.card.deck_id, "card_id" => answer.card_id},
          user_input
        )

      resp = json_response(conn, 200)

      assert resp == %{
               "answer" => %{"id" => answer.id, "content" => "test 123"},
               "distance" => 0.5
             }
    end
  end

  defp setup_card(data \\ %{}) do
    insert(:card, %{user_id: @user_id})
  end

  defp setup_answer(attrs \\ %{}) do
    insert(:answer, Map.merge(%{user_id: @user_id}, attrs))
  end

  defp check_answer(conn, %{"deck_id" => deck_id, "card_id" => card_id}, answer) do
    post(conn, ~p"/decks/#{deck_id}/cards/#{card_id}/answers/check", answer)
  end

  defp post_answer(conn, %{"deck_id" => deck_id, "card_id" => card_id}, data) do
    post(conn, ~p"/decks/#{deck_id}/cards/#{card_id}/answers", data)
  end

  defp put_answer(conn, %{"id" => id, "card_id" => card_id, "deck_id" => deck_id}, data) do
    put(
      conn,
      ~p"/decks/#{deck_id}/cards/#{card_id}/answers/#{id}",
      data
    )
  end

  defp delete_answer(conn, %{"deck_id" => deck_id, "card_id" => card_id, "id" => id}) do
    delete(conn, ~p"/decks/#{deck_id}/cards/#{card_id}/answers/#{id}")
  end

  defp create_answer(_) do
    answer = insert(:answer, %{user_id: @user_id})
    %{answer: answer}
  end
end
