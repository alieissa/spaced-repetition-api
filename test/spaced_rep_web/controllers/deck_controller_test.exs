defmodule SpacedRepWeb.DeckControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory

  alias SpacedRep.TestUtils, as: Utils

  @user_id Ecto.UUID.autogenerate()

  setup %{conn: conn} do
    token = Utils.get_token(%{"sub" => @user_id})

    conn =
      conn
      |> put_req_header("authorization", "bearer #{token}")
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all decks", %{conn: conn} do
      conn = get(conn, ~p"/decks")

      resp = json_response(conn, 200)
      assert resp == []
    end
  end

  describe "POST /decks" do
    @tag :wip
    test "when input data is valid", %{conn: conn} do
      valid_data = %{
        "name" => "Français",
        "description" => "French terms",
        "cards" => [
          %{
            "question" => "Comment ça va?",
            "answers" => [%{"content" => "How are you?"}, %{"content" => "How is it going?"}]
          }
        ]
      }

      conn = post_deck(conn, valid_data)

      resp = json_response(conn, 201)
      assert resp["description"] == valid_data["description"]
      assert Enum.count(resp["cards"]) == Enum.count(valid_data["cards"])
    end

    test "when input data is invalid", %{conn: conn} do
      invalid_data = %{"name" => nil, "description" => "some updated description"}

      conn = post_deck(conn, invalid_data)

      resp = json_response(conn, 422)
      assert resp["errors"]
    end
  end

  describe "PUT /decks/:id" do
    test "when input data is valid", %{conn: conn} do
      deck = setup_deck()

      valid_data = %{
        "name" => "some updated name"
      }

      conn = put_deck(conn, deck.id, valid_data)

      resp = json_response(conn, 200)
      assert resp["name"] == valid_data["name"]
    end

    test "when input data is invalid", %{conn: conn} do
      deck = setup_deck()

      invalid_data = %{"name" => nil, "description" => "some updated description"}

      conn = put_deck(conn, deck.id, invalid_data)

      resp = json_response(conn, 422)
      assert resp["errors"]
    end
  end

  test "DELETE /decks/:id", %{conn: conn} do
    deck = setup_deck()

    conn = delete_deck(conn, deck.id)

    assert response(conn, 204)
  end

  defp setup_deck() do
    insert(:deck, %{user_id: @user_id})
  end

  defp post_deck(conn, data) do
    post(conn, ~p"/decks", data)
  end

  defp put_deck(conn, id, data) do
    put(conn, ~p"/decks/#{id}", data)
  end

  defp delete_deck(conn, id) do
    delete(conn, ~p"/decks/#{id}")
  end
end
