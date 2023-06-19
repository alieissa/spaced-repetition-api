defmodule SpacedRep.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpacedRep.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        interval: 42,
        quality: 42,
        easiness: 42,
        question: "some question",
        next_practice_date: ~N[2023-06-16 21:19:00]
      })
      |> SpacedRep.Cards.create_card()

    card
  end
end
