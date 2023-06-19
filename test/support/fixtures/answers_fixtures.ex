defmodule SpacedRep.AnswersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpacedRep.Answers` context.
  """

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    {:ok, answer} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> SpacedRep.Answers.create_answer()

    answer
  end
end
