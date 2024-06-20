defmodule SpacedRepWeb.UserIDTest do
  use SpacedRepWeb.ConnCase

  alias SpacedRep.TestUtils, as: Utils

  @user_id Ecto.UUID.generate()

  describe "index" do
    test "request without authorization token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> get(~p"/decks")

      assert response(conn, 404)
    end

    test "request with token that does not have sub", %{conn: conn} do
      token = Utils.get_token(%{"foo" => "bar"})

      conn =
        conn
        |> put_req_header("authorization", "bearer #{token}")
        |> get(~p"/decks")

      assert response(conn, 404)
    end

    test "request with valid token", %{conn: conn} do
      token = Utils.get_token(%{"sub" => @user_id})

      conn =
        conn
        |> put_req_header("authorization", "bearer #{token}")
        |> get(~p"/decks")

      assert conn.assigns.user_id == @user_id
    end
  end
end
