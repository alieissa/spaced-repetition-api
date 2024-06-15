defmodule SpacedRep.DecksTest do
  use SpacedRep.DataCase

  alias SpacedRep.Decks
  alias SpacedRep.Decks.Deck
  import SpacedRep.Factory

  @user_id Ecto.UUID.generate()

  describe "decks" do
    @invalid_attrs %{"user_id" => @user_id, "name" => nil, "description" => nil}

    test "list_decks/1 returns all decks of a given user" do
      deck = insert(:deck, %{user_id: @user_id, name: "Test deck"})

      loaded_decks = Decks.list_decks(@user_id)
      decks_with_reset_cards = Enum.map(loaded_decks, &reset_cards_field/1)

      assert decks_with_reset_cards == [deck]
    end

    test "get_deck/2 returns the deck with given id" do
      deck = insert(:deck, %{user_id: @user_id})

      loaded_deck = Decks.get_deck(%{"id" => deck.id, "user_id" => @user_id})
      deck_with_reset_cards = reset_cards_field(loaded_deck)

      assert deck_with_reset_cards == deck
    end

    test "create_deck/2 with valid data creates a deck" do
      valid_attrs = %{
        "user_id" => @user_id,
        "name" => "some name",
        "description" => "some description"
      }

      {:ok, %Deck{} = deck} = Decks.create_deck(valid_attrs)

      assert deck.name == valid_attrs["name"]
      assert deck.description == valid_attrs["description"]
    end

    test "create_deck/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Decks.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = insert(:deck, %{user_id: @user_id})

      updated_attrs = %{
        "user_id" => @user_id,
        "name" => "some updated name",
        "description" => "some updated description"
      }

      {:ok, %Deck{} = deck} = Decks.update_deck(deck.id, updated_attrs)

      assert deck.name == updated_attrs["name"]
      assert deck.description == updated_attrs["description"]
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = insert(:deck, %{user_id: @user_id})

      {:error, %Ecto.Changeset{}} = Decks.update_deck(deck.id, @invalid_attrs)

      loaded_deck = Decks.get_deck(%{"id" => deck.id, "user_id" => @user_id})
      deck_with_reset_cards = reset_cards_field(loaded_deck)

      assert deck_with_reset_cards == deck
    end

    test "delete_deck/2 deletes the deck" do
      deck = insert(:deck, %{user_id: @user_id})

      {:ok, %Deck{} = deleted_deck} = Decks.delete_deck(%{"user_id" => @user_id, "id" => deck.id})

      assert deleted_deck.deleted_at
    end

    test "change_deck/1 returns a deck changeset" do
      deck = insert(:deck)

      assert %Ecto.Changeset{} = Decks.change_deck(deck)
    end
  end

  defp reset_cards_field(deck) do
    Ecto.reset_fields(deck, [:cards])
  end
end
