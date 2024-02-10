defmodule SpacedRep.Decks do
  @moduledoc """
  The Decks context.
  """

  import Ecto.Query, warn: false, only: [from: 2]
  alias SpacedRep.Repo

  alias SpacedRep.Decks.Deck

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

  Raises `Ecto.NoResultsError` if the Deck does not exist.

  ## Examples

      iex> get_deck!(123)
      %Deck{}

      iex> get_deck!(456)
      ** (Ecto.NoResultsError)

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
end
