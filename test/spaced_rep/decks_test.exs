defmodule SpacedRep.DecksTest do
  use SpacedRep.DataCase

  alias SpacedRep.Decks
  alias SpacedRep.Decks.Deck
  import SpacedRep.Factory

  @user_id Ecto.UUID.generate()

  test "list_decks/1" do
    deck = setup_deck()

    loaded_decks = Decks.list_decks(@user_id)

    decks_with_reset_cards = Enum.map(loaded_decks, &reset_cards_field/1)
    assert decks_with_reset_cards == [deck]
  end

  test "get_deck/2" do
    deck = setup_deck()

    loaded_deck = Decks.get_deck(%{"id" => deck.id, "user_id" => @user_id})

    deck_with_reset_cards = reset_cards_field(loaded_deck)
    assert deck_with_reset_cards == deck
  end

  describe "create_deck/2" do
    test "when input data is valid" do
      valid_data = %{
        "name" => "some name",
        "description" => "some description"
      }

      created_deck = create_deck(valid_data)

      assert created_deck.name == valid_data["name"]
      assert created_deck.description == valid_data["description"]
    end

    test "when input data is invalid" do
      invalid_data = %{"name" => nil}

      created_deck = create_deck(invalid_data)

      assert match?(created_deck, nil)
    end
  end

  describe "update_deck/2" do
    test "when input data is valid" do
      deck = setup_deck()

      valid_data = %{
        "name" => "some updated name",
        "description" => "some updated description"
      }

      updated_deck = update_deck(deck.id, valid_data)

      assert updated_deck.name == valid_data["name"]
      assert updated_deck.description == valid_data["description"]
    end

    test "when input data is invalid" do
      deck = setup_deck()

      invalid_data = %{"name" => nil}

      updated_deck = update_deck(deck.id, invalid_data)
      deck_with_reset_cards = reset_cards_field(updated_deck)

      assert deck_with_reset_cards == deck
    end
  end

  test "delete_deck/2" do
    deck = setup_deck()

    deleted_deck = delete_deck(deck.id)

    assert deleted_deck.deleted_at
  end

  defp setup_deck() do
    insert(:deck, %{user_id: @user_id})
  end

  defp create_deck(data) do
    Decks.create_deck(%{"user_id" => @user_id}, data)

    case Decks.list_decks(@user_id) do
      [] -> nil
      [created_deck] -> created_deck
      [created_deck | _] -> created_deck
    end
  end

  defp update_deck(id, data) do
    Decks.update_deck(%{"id" => id, "user_id" => @user_id}, data)
    Decks.get_deck(%{"id" => id, "user_id" => @user_id})
  end

  defp delete_deck(id) do
    Decks.delete_deck(%{"id" => id, "user_id" => @user_id})
    Decks.get_deck(%{"id" => id, "user_id" => @user_id})
  end

  defp reset_cards_field(deck) do
    Ecto.reset_fields(deck, [:cards])
  end
end
