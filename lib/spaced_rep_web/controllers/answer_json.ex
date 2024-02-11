defmodule SpacedRepWeb.AnswerJSON do
  alias SpacedRep.Answers.Answer

  @doc """
  Renders a list of answers.
  """
  def index(%{answers: answers}) do
    for(answer <- answers, do: data(answer))
  end

  @doc """
  Renders a single answer and comparison distance
  """
  def show(%{answer: answer, distance: distance}) do
    %{distance: distance, answer: data(answer)}
  end

  @doc """
  Renders a single answer.
  """
  def show(%{answer: answer}) do
    data(answer)
  end

  defp data(%Answer{} = answer) do
    %{
      id: answer.id,
      content: answer.content
    }
  end
end
