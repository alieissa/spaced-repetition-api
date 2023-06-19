defmodule SpacedRep.AnswersTest do
  use SpacedRep.DataCase

  alias SpacedRep.Answers
  alias SpacedRep.Answers.Answer
  import SpacedRep.Factory

  describe "answers" do
    @invalid_attrs %{content: nil}

    test "list_answers/1 returns all answers" do
      answer = insert(:answer) |> reset_fields([:card])
      assert Answers.list_answers(answer.card_id) == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = insert(:answer) |> reset_fields([:card])
      assert Answers.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Answer{} = answer} = Answers.create_answer(valid_attrs)
      assert answer.content == "some content"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Answers.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = insert(:answer) |> reset_fields([:card])
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Answer{} = answer} = Answers.update_answer(answer, update_attrs)
      assert answer.content == "some updated content"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = insert(:answer) |> reset_fields([:card])
      assert {:error, %Ecto.Changeset{}} = Answers.update_answer(answer, @invalid_attrs)
      assert answer == Answers.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = insert(:answer)
      assert {:ok, %Answer{}} = Answers.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Answers.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = insert(:answer) |> reset_fields([:card])
      assert %Ecto.Changeset{} = Answers.change_answer(answer)
    end
  end
end
