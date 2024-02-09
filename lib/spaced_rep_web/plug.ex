# Reference: https://blog.jola.dev/health-checks-for-plug-and-phoenix
defmodule SpacedRepWeb.Plug do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(200, "healthy")
    |> halt()
  end

  def call(conn, _opts) do
    # 2. Nested case can get hard to read, use with
    # Refer to https://stackoverflow.com/questions/50827551/elixir-how-to-avoid-deeply-nested-case-statements
    case get_req_header(conn, "authorization") do
      [token] ->
        case JOSE.JWT.peek_payload(token) do
          %JOSE.JWT{fields: %{"sub" => user_id}} ->
            assign(conn, :user_id, user_id)

          _ ->
            conn |> send_resp(404, "Nothing found") |> halt()
        end

      _ ->
        conn |> send_resp(404, "Nothing found") |> halt()
    end
  end
end
