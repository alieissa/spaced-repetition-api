defmodule SpacedRep.CardsTest do
  use SpacedRep.DataCase

  alias SpacedRep.Cards
  alias SpacedRep.Cards.Card

  alias Ecto.UUID
  import SpacedRep.Factory

  describe "cards" do
    @invalid_attrs %{
      interval: nil,
      quality: nil,
      easiness: nil,
      question: nil,
      next_practice_date: nil
    }

    @tag :skip
    test "list_cards/1 returns all cards" do
      card = insert(:card) |> reset_fields([:deck])
      assert Cards.list_cards(card.deck_id) == [card]
    end

    @tag :skip
    test "get_card!/1 returns the card with given id" do
      card = insert(:card) |> reset_fields([:deck])
      assert Cards.get_card!(card.id) == card
    end

    @tag :skip
    test "create_card/1 with minimal data" do
      deck = insert(:deck)

      valid_minimal_attrs = %{
        question: "some minimal question",
        deck_id: deck.id
      }

      assert {:ok, %Card{} = card} = Cards.create_card(valid_minimal_attrs)
      assert card.interval == 1
      assert card.quality == 3
      assert card.easiness == 2.5
      assert card.question == "some minimal question"
      # TODO Add assertion for next_practice_date
    end

    @tag :skip
    test "create_card/1 with valid data creates a card" do
      deck = insert(:deck)

      valid_attrs = %{
        deck_id: deck.id,
        interval: 4,
        quality: 1,
        easiness: 1.3,
        question: "some question"
      }

      assert {:ok, %Card{} = card} = Cards.create_card(valid_attrs)
      assert card.interval == 4
      assert card.quality == 1
      assert card.easiness == 1.3
      assert card.question == "some question"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_card(@invalid_attrs)
    end

    test "update_card/2 when new quality is larger than 3 and repetitions is 0" do
      card = insert(:card, %{repetitions: 0})

      updated_attrs = %{
        "quality" => 4
      }

      assert {:ok, %Card{} = card} = Cards.update_card(card, updated_attrs)
      assert card.quality == 4
      assert card.repetitions == 1
      assert card.interval == 1
    end

    test "update_card/2 when new quality is larger than 3 and repetitions is 1" do
      card = insert(:card, %{repetitions: 1})

      updated_attrs = %{
        "quality" => 4
      }

      assert {:ok, %Card{} = card} = Cards.update_card(card, updated_attrs)
      assert card.quality == 4
      assert card.repetitions == 2
      assert card.interval == 6
    end

    test "update_card/2 when new quality is more than 3 and repetitions is more than 1" do
      card = insert(:card, %{repetitions: 2, interval: 6, easiness: 4.1})

      updated_attrs = %{
        "quality" => 4
      }

      assert {:ok, %Card{} = card} = Cards.update_card(card, updated_attrs)

      assert card.quality == 4
      assert card.easiness == 4.1
      assert card.repetitions == 3
      # (easiness * interval) rounded
      assert card.interval == 24
    end

    # When quality is less than 3 the interval and repetitions are reset
    # to 1 and 0 respectively. Since interval is what determines the next
    # practice date, it is not necessary to update any of the other values
    test "update_card/2 when new quality is less than 3" do
      card = insert(:card, %{interval: 6, repetitions: 5})

      updated_attrs = %{
        "quality" => 2
      }

      assert {:ok, %Card{} = card} = Cards.update_card(card, updated_attrs)
      assert card.quality == 2
      assert card.repetitions == 0
      assert card.interval == 1
    end

    test "update_card/2 with valid data updates the card" do
      card = insert(:card)

      updated_attrs = %{
        interval: 4,
        quality: 1,
        easiness: 1.3,
        question: "some updated question"
      }

      assert {:ok, %Card{} = card} = Cards.update_card(card, updated_attrs)
      assert card.interval == 4
      assert card.quality == 1
      assert card.easiness == 1.3
      assert card.question == "some updated question"
    end

    @tag :skip
    test "update_card/2 with invalid data returns error changeset" do
      card = insert(:card) |> reset_fields([:deck])
      assert {:error, %Ecto.Changeset{}} = Cards.update_card(card, @invalid_attrs)
      assert card == Cards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = insert(:card)
      assert {:ok, %Card{}} = Cards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = insert(:card)
      assert %Ecto.Changeset{} = Cards.change_card(card)
    end
  end
end
