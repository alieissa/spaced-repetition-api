defmodule SpacedRepWeb.AnswerController do
  use SpacedRepWeb, :controller

  alias SpacedRep.Answers
  alias SpacedRep.Answers.Answer

  action_fallback SpacedRepWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.path_params, conn.body_params]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"card_id" => card_id}, _body_params) do
    answers = Answers.list_answers(card_id)
    render(conn, :index, answers: answers)
  end

  def create(conn, %{"deck_id" => deck_id, "card_id" => card_id}, answer_params) do
    with {:ok, %Answer{} = answer} <- Answers.create_answer(answer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/decks/#{deck_id}/cards/#{card_id}/answers/#{answer}")
      |> render(:show, answer: answer)
    end
  end

  def show(conn, %{"id" => id}, _body_params) do
    answer = Answers.get_answer!(id)
    render(conn, :show, answer: answer)
  end

  def update(conn, %{"id" => id}, answer_params) do
    answer = Answers.get_answer!(id)

    with {:ok, %Answer{} = answer} <- Answers.update_answer(answer, answer_params) do
      render(conn, :show, answer: answer)
    end
  end

  def delete(conn, %{"id" => id}, _) do
    answer = Answers.get_answer!(id)

    with {:ok, %Answer{}} <- Answers.delete_answer(answer) do
      send_resp(conn, :no_content, "")
    end
  end

  def check(conn, %{"card_id" => card_id}, %{"answer" => answer}) do
    with answers <- Answers.list_answers(card_id) do
      closest_distance = get_closest(answer, answers)

      conn
      |> resp(:ok, "#{closest_distance}")
      |> send_resp()
    end
  end

  defp get_closest(user_answer, answers) do
    get_distance = fn answer ->
      distance = Levenshtein.distance(user_answer, answer.content)

      normalized_distance =
        distance / max(String.length(user_answer), String.length(answer.content))

      normalized_distance
    end

    [head | _] = answers |> Enum.map(get_distance) |> Enum.sort()
    head
  end
end
