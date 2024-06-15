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

      iex> list_decks()
      nil

  """
  def list_decks(user_id) do
    query = from d in Deck, where: d.user_id == ^user_id
    query |> Repo.all() |> Repo.preload(cards: [:answers])
  end

  @doc """
  Gets a single deck.

  Return `nil` if the Deck does not exist.

  ## Examples

      iex> get_deck(%{"id" => 123, "user_id" => 123})
      %Deck{}

      iex> get_deck(%{"id" => 123, "user_id" => 456})
      nil

  """
  def get_deck(%{"id" => id, "user_id" => user_id}) do
    query = from d in Deck, where: d.id == ^id and d.user_id == ^user_id
    query |> Repo.one() |> Repo.preload(cards: [:answers])
  end

  @doc """
  Creates a deck.

  ## Examples

      iex> create_deck(%{"name"=> "new deck"})
      {:ok, %Deck{}}

      iex> create_deck(%{"name" => nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_deck(attrs \\ %{}) do
    %Deck{}
    |> Deck.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, deck} -> {:ok, Repo.preload(deck, cards: [:answers])}
      error -> error
    end
  end

  @doc """
  Updates a deck.

  ## Examples

      iex> update_deck(123, %{"name" => "updated name"})
      {:ok, %Deck{}}

      iex> update_deck(456, %{"name" => nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_deck(id, %{"user_id" => _user_id} = attrs) do
    %Deck{id: id}
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

      iex> upload_decks([%{"user_id" => 123, "name" => "new deck"}])
      {:ok, [%Deck{}]}

      iex> upload_decks([%{"user_id" => 123, "name" => nil}])
      {:error, %Ecto.Changeset{}}

  """
  def upload_decks(decks) do
    mapped_decks = Enum.map(decks, &map_imported_deck/1)

    ops =
      Enum.reduce(mapped_decks, Ecto.Multi.new(), fn deck, acc ->
        Ecto.Multi.insert(
          acc,
          deck.name,
          Deck.changeset(%Deck{}, deck)
        )
      end)

    Repo.transaction(ops)
  end

  @doc """
  Deletes a deck.

  ## Examples

      iex> delete_deck(%{"id" => 123, "user_id" => 456})
      {:ok, %Deck{deleted_at: 01/01/1970}}

      iex> delete_deck(%{"id" => 123, "user_id" => 678})
      {:error, %Ecto.Changeset{}}

  """
  def delete_deck(%{"id" => id, "user_id" => user_id}) do
    %Deck{id: id, user_id: user_id}
    |> change_deck(%{deleted_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deck changes.

  ## Examples

      iex> change_deck(deck)
      %Ecto.Changeset{data: %Deck{}}

  """
  def change_deck(deck, attrs \\ %{}) do
    Deck.changeset(deck, attrs)
  end

  @doc """
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
