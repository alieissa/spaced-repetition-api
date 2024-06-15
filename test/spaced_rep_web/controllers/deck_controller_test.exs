defmodule SpacedRepWeb.DeckControllerTest do
  use SpacedRepWeb.ConnCase

  import SpacedRep.Factory

  alias SpacedRep.TestUtils, as: Utils

  @user_id Ecto.UUID.autogenerate()
  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil, description: "some updated description"}

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
      assert json_response(conn, 200) == []
    end
  end

  describe "create deck" do
    test "renders deck when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/decks", @create_attrs)

      assert %{"description" => "some description", "name" => "some name"} =
               json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/decks", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update deck" do
    test "renders deck when data is valid", %{conn: conn} do
      %{id: id} = insert(:deck, %{user_id: @user_id})
      conn = put(conn, ~p"/decks/#{id}", @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/decks/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{id: id} = insert(:deck, %{user_id: @user_id})
      conn = put(conn, ~p"/decks/#{id}", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete deck" do
    test "deletes chosen deck", %{conn: conn} do
      deck = insert(:deck, %{name: "test123"})
      conn = delete(conn, ~p"/decks/#{deck}")
      assert response(conn, 204)

      conn = get(conn, ~p"/decks/#{deck}")
      assert response(conn, 404)
    end
  end
end
