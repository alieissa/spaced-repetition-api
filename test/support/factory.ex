defmodule SpacedRep.Factory do
  use ExMachina.Ecto, repo: SpacedRep.Repo

  alias Ecto.UUID
  alias SpacedRep.{Decks.Deck, Cards.Card, Answers.Answer}

  def deck_factory(attrs \\ %{}) do
    deck_defaults = %{
      user_id: UUID.autogenerate(),
      name: "dummy deck",
      description: "Dummy test deck"
    }

    deck = Map.merge(deck_defaults, attrs)
    struct(Deck, deck)
  end

  def card_factory(attrs \\ %{}) do
    card_defaults = %{
      question: "dummy question",
      answers: [],
      easiness: 1.3,
      quality: 1,
      interval: 1,
      repetitions: 0,
      next_practice_date: DateTime.utc_now(),
      deck: build(:deck)
    }

    card = Map.merge(card_defaults, attrs)
    struct(Card, card)
  end

  def answer_factory(attrs \\ %{}) do
    answer_defaults = %{
      content: "some answer",
      card: insert(:card)
    }

    answer = Map.merge(answer_defaults, attrs)
    struct(Answer, answer)
  end
end
