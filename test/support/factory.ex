defmodule SpacedRep.Factory do
  use ExMachina.Ecto, repo: SpacedRep.Repo

  alias Ecto.UUID
  alias SpacedRep.{Decks.Deck, Cards.Card, Answers.Answer}

  def deck_factory(attrs \\ %{}) do
    user_id = UUID.autogenerate()

    deck_defaults = %{
      user_id: user_id,
      name: "dummy deck",
      description: "Dummy test deck",
      cards: [
        %{
          question: "Dummy question",
          answers: [%{content: "Dummy answers", user_id: user_id}],
          user_id: user_id
        }
      ]
    }

    deck = Map.merge(deck_defaults, attrs)
    struct(Deck, deck)
  end

  def card_factory(attrs \\ %{}) do
    user_id = UUID.generate()

    card_defaults = %{
      question: "dummy question",
      answers: [%{content: "dummy answer", user_id: user_id}],
      easiness: 1.3,
      quality: 1,
      interval: 1,
      repetitions: 0,
      next_practice_date: DateTime.utc_now(),
      user_id: user_id,
      deck: build(:deck)
    }

    card = Map.merge(card_defaults, attrs)
    struct(Card, card)
  end

  def answer_factory(%{user_id: user_id} = attrs) do
    answer_defaults = %{
      content: "some answer",
      user_id: user_id,
      card: insert(:card, %{user_id: user_id})
    }

    answer = Map.merge(answer_defaults, attrs)
    struct(Answer, answer)
  end
end
