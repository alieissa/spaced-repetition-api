defmodule SpacedRep.DecksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpacedRep.Decks` context.
  """

  @doc """
  Generate a deck.
  """
  def deck_fixture(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description"
      })
      |> SpacedRep.Decks.create_deck()

    deck
  end
end
