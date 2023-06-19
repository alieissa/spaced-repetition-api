defmodule SpacedRepWeb.AnswerJSON do
  alias SpacedRep.Answers.Answer

  @doc """
  Renders a list of answers.
  """
  def index(%{answers: answers}) do
    %{data: for(answer <- answers, do: data(answer))}
  end

  @doc """
  Renders a single answer.
  """
  def show(%{answer: answer}) do
    %{data: data(answer)}
  end

  defp data(%Answer{} = answer) do
    %{
      id: answer.id,
      content: answer.content
    }
  end
end
