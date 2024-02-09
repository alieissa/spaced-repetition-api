defmodule SpacedRepWeb.HealthCheckControllerTest do
  use SpacedRepWeb.ConnCase

  alias SpacedRep.TestUtils, as: Utils

  describe "index" do
    test "health", %{conn: conn} do
      conn = get(conn, ~p"/health")

      assert "healthy" = response(conn, 200)
    end

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
      token = Utils.get_token(%{"sub" => "dummy_user_id"})

      conn =
        conn
        |> put_req_header("authorization", "bearer #{token}")
        |> get(~p"/decks")

      assert conn.assigns.user_id == "dummy_user_id"
    end
  end
end
