defmodule SpacedRepWeb.CardJSON do
  alias SpacedRep.Cards.Card

  @doc """
  Renders a list of cards.
  """
  def index(%{cards: cards}) do
    for(card <- cards, do: data(card))
  end

  @doc """
  Renders a single card.
  """
  def show(%{card: card}) do
    data(card)
  end

  defp data(%Card{} = card) do
    %{
      id: card.id,
      deck_id: card.deck_id,
      quality: card.quality,
      easiness: card.easiness,
      interval: card.interval,
      repetitions: card.repetitions,
      question: card.question,
      next_practice_date: card.next_practice_date
    }
  end
end
