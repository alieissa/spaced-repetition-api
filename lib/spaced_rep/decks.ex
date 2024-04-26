defmodule SpacedRep.Decks do
  @moduledoc """
  The Decks context.
  """

  import Ecto.Query, warn: false, only: [from: 2]
  alias SpacedRep.Repo

  alias SpacedRep.Decks.Deck
  alias SpacedRep.Cards.Card
  alias SpacedRep.Answers.Answer

  @doc """
  Returns the list of decks.

  ## Examples

      iex> list_decks()
      [%Deck{}, ...]

  """
  def list_decks do
    Repo.all(Deck)
  end

  @doc """
  Gets a single deck.

  Return `nil` if the Deck does not exist.

  ## Examples

      iex> get_deck(123)
      %Deck{}

      iex> get_deck(456)
      nil

  """
  def get_deck(id) do
    query = from d in Deck, where: is_nil(d.deleted_at) and d.id == ^id

    Repo.one(query) |> Repo.preload(cards: [:answers])
  end

  @doc """
  Creates a deck.

  ## Examples

      iex> create_deck(%{field: value})
      {:ok, %Deck{}}

      iex> create_deck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deck(user_id, attrs \\ %{}) do
    %Deck{}
    |> Deck.changeset(user_id, attrs)
    |> Repo.insert()
    |> case do
      {:ok, deck} -> {:ok, Repo.preload(deck, cards: [:answers])}
      error -> error
    end
  end

  @doc """
  Updates a deck.

  ## Examples

      iex> update_deck(deck, %{field: new_value})
      {:ok, %Deck{}}

      iex> update_deck(deck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deck(%Deck{} = deck, attrs) do
    deck
    |> Deck.changeset(attrs)
    ## TODO Upsert nested cards and answers
    |> Repo.update()
    |> case do
      {:ok, deck} -> {:ok, Repo.preload(deck, cards: [:answers])}
      error -> error
    end
  end

  @doc """
  Uploads/inserts a list of decks.

  ## Examples

      iex> upload_decks(decks, user_id)
      {:ok, %Deck{}}

      iex> upload_decks(decks, user_id)
      {:error, %Ecto.Changeset{}}

  """
  def upload_decks(decks, user_id) do
    mapped_decks = Enum.map(decks, &map_imported_deck/1)

    ops =
      Enum.reduce(mapped_decks, Ecto.Multi.new(), fn deck, acc ->
        Ecto.Multi.insert(
          acc,
          deck.name,
          Deck.changeset(deck, user_id, %{})
        )
      end)

    Repo.transaction(ops)
  end

  @doc """
  Deletes a deck.

  ## Examples

      iex> delete_deck(deck)
      {:ok, %Deck{}}

      iex> delete_deck(deck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deck(id) do
    %Deck{id: id}
    |> change_deck(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deck changes.

  ## Examples

      iex> change_deck(deck)
      %Ecto.Changeset{data: %Deck{}}

  """
  def change_deck(%Deck{} = deck, attrs \\ %{}) do
    Deck.changeset(deck, attrs)
  end

  """
  Maps a list of %ImportedDeck{} to a list of %Deck{}
  """

  defp map_imported_deck(%{"name" => name, "cards" => imported_cards}) do
    map_answers = fn answers ->
      Enum.map(answers, fn answer -> %Answer{content: answer} end)
    end

    cards =
      Enum.map(imported_cards, fn card ->
        %Card{question: card["question"], answers: map_answers.(card["answers"])}
      end)

    %Deck{name: name, cards: cards}
  end
end
