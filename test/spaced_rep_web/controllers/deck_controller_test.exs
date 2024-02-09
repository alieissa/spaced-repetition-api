defmodule SpacedRepWeb.DeckControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory

  alias Ecto.UUID
  alias SpacedRep.Decks.Deck
  alias SpacedRep.TestUtils, as: Utils

  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil, description: "some updated description"}

  setup %{conn: conn} do
    token = Utils.get_token(%{"sub" => UUID.autogenerate()})

    conn =
      conn
      |> put_req_header("authorization", "bearer #{token}")
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all decks", %{conn: conn} do
      conn = get(conn, ~p"/decks")
      assert json_response(conn, 200) == []
    end
  end

  describe "create deck" do
    test "renders deck when data is valid", %{conn: conn} do
      # Conn.assign(conn, :user_id, UUID.autogenerate())

      conn =
        conn
        |> assign(:usr_id, UUID.autogenerate())
        |> post(~p"/decks", @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/decks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/decks", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update deck" do
    setup [:create_deck]

    test "renders deck when data is valid", %{conn: conn, deck: %Deck{id: id}} do
      conn = put(conn, ~p"/decks/#{id}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/decks/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, deck: deck} do
      conn = put(conn, ~p"/decks/#{deck}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete deck" do
    setup [:create_deck]

    @tag :skip
    test "deletes chosen deck", %{conn: conn, deck: deck} do
      conn = delete(conn, ~p"/decks/#{deck}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/decks/#{deck}")
      end
    end
  end

  defp create_deck(_) do
    deck = insert(:deck)
    %{deck: deck}
  end
end

# %Deck{"id" => id} = deck
