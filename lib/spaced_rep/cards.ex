defmodule SpacedRep.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false
  alias SpacedRep.Repo

  alias SpacedRep.Cards.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards(deck_id)
      [%Card{}, ...]

  """
  def list_cards(%{"user_id" => user_id, "deck_id" => deck_id}) do
    query =
      from c in Card,
        where: c.deck_id == ^deck_id and c.user_id == ^user_id and is_nil(c.deleted_at)

    Repo.all(query) |> Repo.preload(:answers)
  end

  @doc """
  Gets a single card.

  Returns `nil` if the Card does not exist.

  ## Examples

      iex> get_card({"id" => 123, "user_id": 456})
      %Card{}

      iex> get_card({"id" => 123, "user_id": 678})
      ** nil

  """
  def get_card(%{"id" => id, "user_id" => user_id}) do
    query = from c in Card, where: c.id == ^id and c.user_id == ^user_id and is_nil(c.deleted_at)
    query |> Repo.one() |> Repo.preload(:answers)
  end

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{"user_id" => 123, "deck_id" => 456}, %{"question"=> "How are you?"})
      {:ok, %Card{}}

      iex> create_card(%{"user_id" => 123, "deck_id" => 456}, %{"question"=> nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(%{"user_id" => user_id, "deck_id" => deck_id}, attrs) do
    %Card{user_id: user_id, deck_id: deck_id}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(%{"id" => 123, "user_id" => 456}, %{"question" => "Comment ça va?"})
      {:ok, %Card{}}

      iex> update_card(%{"id" => 123, "user_id" => 456}, %{"question" => nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%{"id" => id, "user_id" => user_id}, attrs) do
    card = get_card(%{"id" => id, "user_id" => user_id})
    updated_attrs = get_updated_attrs(card, attrs)

    card
    |> Card.changeset(updated_attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(%{"id" => 123, "user_id" => 456})
      {:ok, %Card{}}

      iex> delete_card(%{"id" => 123, "user_id" => 789})
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%{"id" => id, "user_id" => user_id}) do
    update_card(%{"id" => id, "user_id" => user_id}, %{"deleted_at" => DateTime.utc_now()})
  end

  defp get_updated_attrs(%Card{} = card, %{"quality" => quality} = attrs)
       when is_number(quality) and card.quality !== quality do
    dq = 5 - quality
    updated_easiness = max(1.3, card.easiness + (0.1 - dq * (0.08 + dq * 0.02)))
    updated_easiness = Float.round(updated_easiness, 1)

    updated_repetitions = if quality < 3, do: 0, else: card.repetitions + 1

    updated_interval =
      if quality < 3 do
        1
      else
        case card.repetitions do
          0 -> 1
          1 -> 6
          _ -> trunc(card.interval * updated_easiness)
        end
      end

    next_practice_date =
      DateTime.utc_now()
      |> DateTime.add(updated_interval, :day)

    Map.merge(
      attrs,
      %{
        "easiness" => updated_easiness,
        "repetitions" => updated_repetitions,
        "interval" => updated_interval,
        "next_practice_date" => next_practice_date
      }
    )
  end

  defp get_updated_attrs(%Card{}, attrs) do
    attrs
  end
end
