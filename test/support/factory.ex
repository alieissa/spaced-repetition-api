defmodule SpacedRep.Factory do
  use ExMachina.Ecto, repo: SpacedRep.Repo

  alias SpacedRep.{Decks.Deck, Cards.Card, Answers.Answer}

  def deck_factory do
    %Deck{
      name: "dummy deck",
      description: "Dummy test deck"
    }
  end

  def card_factory do
    %Card{
      question: "dummy question",
      easiness: 1.3,
      quality: 1,
      interval: 1,
      repetitions: 0,
      next_practice_date: DateTime.utc_now(),
      deck: build(:deck)
    }
  end

  def answer_factory do
    %Answer{
      content: "some answer",
      card: insert(:card)
    }
  end
end
