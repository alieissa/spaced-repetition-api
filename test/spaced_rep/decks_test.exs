defmodule SpacedRep.DecksTest do
  use SpacedRep.DataCase

  alias SpacedRep.Decks
  alias SpacedRep.Decks.Deck

  alias Ecto.UUID
  import SpacedRep.Factory

  describe "decks" do
    @invalid_attrs %{name: nil, description: nil}

    @tag :skip
    test "list_decks/0 returns all decks" do
      deck = insert(:deck)
      assert Decks.list_decks() == [deck]
    end

    @tag :skip
    test "get_deck!/1 returns the deck with given id" do
      deck = insert(:deck)
      assert Decks.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      valid_attrs = %{name: "some name", description: "some description"}
      user_id = UUID.autogenerate()

      assert {:ok, %Deck{} = deck} = Decks.create_deck(user_id, valid_attrs)
      assert deck.name == "some name"
      assert deck.description == "some description"
    end

    @tag :skip
    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Decks.create_deck(@invalid_attrs)
    end

    @tag :skip
    test "update_deck/2 with valid data updates the deck" do
      deck = insert(:deck)
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Deck{} = deck} = Decks.update_deck(deck, update_attrs)
      assert deck.name == "some updated name"
      assert deck.description == "some updated description"
    end

    @tag :skip
    test "update_deck/2 with invalid data returns error changeset" do
      deck = insert(:deck)
      assert {:error, %Ecto.Changeset{}} = Decks.update_deck(deck, @invalid_attrs)
      assert deck == Decks.get_deck!(deck.id)
    end

    @tag :skip
    test "delete_deck/1 deletes the deck" do
      deck = insert(:deck)
      assert {:ok, %Deck{}} = Decks.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Decks.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      deck = insert(:deck)
      assert %Ecto.Changeset{} = Decks.change_deck(deck)
    end
  end
end
