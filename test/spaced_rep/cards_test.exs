defmodule SpacedRep.CardsTest do
  use SpacedRep.DataCase

  alias SpacedRep.Cards

  import SpacedRep.Factory

  @user_id Ecto.UUID.generate()

  test "list_cards/1" do
    card = setup_card()

    loaded_cards = load_cards(card.deck_id)

    assert loaded_cards == [card]
  end

  test "get_card/1" do
    card = setup_card()

    loaded_card = load_card(card.id)

    assert loaded_card == card
  end

  describe "create_card/1" do
    test "when input data is valid" do
      deck = setup_deck()

      data = %{
        interval: 4,
        quality: 1,
        easiness: 1.3,
        question: "some question",
        deck_id: deck.id,
        user_id: @user_id
      }

      created_card = create_card(deck.id, data)

      assert created_card.interval == data.interval
      assert created_card.quality == data.quality
      assert created_card.easiness == data.easiness
      assert created_card.question == data.question
    end

    test "when input data is invalid" do
      deck = setup_deck()

      invalid_data = %{"question" => nil}
      created_card = create_card(deck.id, invalid_data)

      assert match?(^created_card, nil)
    end
  end

  describe "update_card/2 when new quality is more than 3" do
    test "repetitions is 0" do
      card = setup_card(%{repetitions: 0})

      data = %{
        "quality" => 4
      }

      updated_card = update_card(card.id, data)

      assert updated_card.quality == data["quality"]
      assert updated_card.repetitions == 1
      assert updated_card.interval == 1
    end

    test "repetitions is 1" do
      card = setup_card(%{repetitions: 1})

      data = %{
        "quality" => 4
      }

      updated_card = update_card(card.id, data)

      assert updated_card.quality == data["quality"]
      assert updated_card.repetitions == 2
      assert updated_card.interval == 6
    end

    test "repetitions is more than 1" do
      card = setup_card(%{repetitions: 2, quality: 2, interval: 6, easiness: 4.1})

      data = %{
        "quality" => 4
      }

      updated_card = update_card(card.id, data)

      assert updated_card.quality == data["quality"]
      assert updated_card.easiness == 4.1
      assert updated_card.repetitions == 3
      # (easiness * interval) rounded
      assert updated_card.interval == 24
    end
  end

  # When quality is less than 3 the interval and repetitions are reset
  # to 1 and 0 respectively. Since interval is what determines the next
  # practice date, it is not necessary to update any of the other values
  test "update_card/2 when new quality is less than 3" do
    card = setup_card(%{interval: 6, quality: 4, repetitions: 5})

    data = %{
      "quality" => 2
    }

    updated_card = update_card(card.id, data)

    assert updated_card.quality == data["quality"]
    assert updated_card.repetitions == 0
    assert updated_card.interval == 1
  end

  test "update_card/2 when new quality is same as incumbent quality" do
    card = setup_card(%{quality: 1})

    data = %{
      "interval" => 4,
      "quality" => 1,
      "easiness" => 1.3,
      "question" => "some updated question"
    }

    updated_card = update_card(card.id, data)

    assert updated_card.interval == data["interval"]
    assert updated_card.quality == data["quality"]
    assert updated_card.easiness == data["easiness"]
    assert updated_card.question == data["question"]
  end

  test "update_card/2 when input data is invalid" do
    card = setup_card()

    invalid_data = %{
      interval: nil,
      quality: nil,
      easiness: nil,
      question: nil
    }

    updated_card = update_card(card.id, invalid_data)

    assert updated_card == card
  end

  test "delete_card/1" do
    card = setup_card()

    deleted_card = delete_card(card.id)

    assert deleted_card.deleted_at
  end

  defp setup_card(data \\ %{}) do
    insert(:card, Map.merge(%{user_id: @user_id}, data)) |> reset_fields([:deck])
  end

  defp setup_deck do
    insert(:deck)
  end

  defp load_cards(deck_id) do
    Cards.list_cards(%{"user_id" => @user_id, "deck_id" => deck_id})
  end

  defp load_card(id) do
    Cards.get_card(%{"id" => id, "user_id" => @user_id})
  end

  defp create_card(deck_id, data) do
    Cards.create_card(%{"user_id" => @user_id, "deck_id" => deck_id}, data)

    case Cards.list_cards(%{"user_id" => @user_id, "deck_id" => deck_id}) do
      [] -> nil
      [created_card] -> created_card
      [created_card | _] -> created_card
    end
  end

  defp update_card(id, data) do
    Cards.update_card(%{"id" => id, "user_id" => @user_id}, data)
    Cards.get_card(%{"id" => id, "user_id" => @user_id})
  end

  defp delete_card(id) do
    {:ok, card} = Cards.delete_card(%{"id" => id, "user_id" => @user_id})
    card
  end
end
