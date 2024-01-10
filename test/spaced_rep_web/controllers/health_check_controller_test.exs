defmodule SpacedRepWeb.HealthCheckControllerTest do
  use SpacedRepWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "health", %{conn: conn} do
      conn = get(conn, ~p"/health")

      assert "healthy" = response(conn, 200)
    end
  end
end
