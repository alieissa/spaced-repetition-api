defmodule SpacedRepWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use SpacedRepWeb, :controller

  # This clause handles empty responses returned by Ecto's get.
  def call(conn, nil) do
    conn
    |> resp(:not_found, "")
    |> send_resp()
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: SpacedRepWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end
end
