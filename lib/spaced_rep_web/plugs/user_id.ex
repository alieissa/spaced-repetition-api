# Reference: https://blog.jola.dev/health-checks-for-plug-and-phoenix
defmodule SpacedRepWeb.Plugs.UserID do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "authorization"),
         %JOSE.JWT{fields: %{"sub" => user_id}} <- JOSE.JWT.peek_payload(token) do
      assign(conn, :user_id, user_id)
    else
      _ -> conn |> send_resp(404, "Nothing found") |> halt()
    end
  end
end
