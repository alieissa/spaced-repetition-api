# Reference: https://blog.jola.dev/health-checks-for-plug-and-phoenix
defmodule SpacedRepWeb.Plugs.HealthCheck do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(200, "healthy")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
