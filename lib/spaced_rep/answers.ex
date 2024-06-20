defmodule SpacedRep.Answers do
  @moduledoc """
  The Answers context.
  """

  import Ecto.Query, warn: false
  alias SpacedRep.Repo

  alias SpacedRep.Answers.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers(%{"id" => 123, "user_id" => 456})
      [%Answer{}, ...]

  """
  def list_answers(%{"user_id" => user_id, "card_id" => card_id}) do
    query = from a in Answer, where: a.user_id == ^user_id and a.card_id == ^card_id
    Repo.all(query)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer(%{"id" => 123, "user_id" => 456})
      %Answer{}

      iex> get_answer(%{"id" => 123, "user_id" => 789})
      nil

  """
  def get_answer(%{"id" => id, "user_id" => user_id}) do
    query =
      from a in Answer, where: a.id == ^id and a.user_id == ^user_id and is_nil(a.deleted_at)

    Repo.one(query)
  end

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{"id" => 123, "user_id" => 456}, %{content: "How are you?"})
      {:ok, %Answer{}}

      iex> create_answer(%{"id" => 123, "user_id" => 456}, %{content: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(%{"user_id" => user_id, "card_id" => card_id}, attrs \\ %{}) do
    %Answer{user_id: user_id, card_id: card_id}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(%{"id" => 123, "user_id" => 456}, %{content: "How is it going?"})
      {:ok, %Answer{}}

      iex> update_answer(%{"id" => 123, "user_id" => 456}, %{content: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%{"id" => id, "user_id" => user_id}, attrs \\ %{}) do
    %Answer{id: id, user_id: user_id}
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(%{"id" => 123, "user_id" => 456})
      {:ok, %Answer{}}

      iex> delete_answer(delete_answer(%{"id" => 123, "user_id" => 789}))
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%{"id" => id, "user_id" => user_id}) do
    update_answer(%{"id" => id, "user_id" => user_id}, %{"deleted_at" => DateTime.utc_now()})
  end
end
