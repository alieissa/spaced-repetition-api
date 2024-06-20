defmodule SpacedRep.AnswersTest do
  use SpacedRep.DataCase

  import SpacedRep.Factory
  alias SpacedRep.Answers

  @user_id Ecto.UUID.generate()

  test "list_answers/1" do
    answer = setup_answer()

    loaded_answers = load_answers(answer.card_id)

    assert loaded_answers == [answer]
  end

  test "get_answer/1" do
    answer = setup_answer()

    loaded_answer = load_answer(answer.id)

    assert loaded_answer == answer
  end

  describe "create_answer/1" do
    test "when input data is valid" do
      card = setup_card()

      data = %{"content" => "How are you"}
      created_answer = create_answer(card.id, data)

      assert created_answer.content == data["content"]
    end

    test "when input data is invalid" do
      card = setup_card()

      invalid_data = %{"content" => nil}
      created_answer = create_answer(card.id, invalid_data)

      assert match?(^created_answer, nil)
    end
  end

  describe "update_answer/2" do
    test "when input data is valid" do
      answer = setup_answer()

      data = %{"content" => "some updated content"}
      updated_answer = update_answer(answer.id, data)

      assert updated_answer.content == data["content"]
    end

    test "when input data is invalid" do
      answer = setup_answer()

      invalid_data = %{"content" => nil}
      updated_answer = update_answer(answer.id, invalid_data)

      assert updated_answer.content
    end
  end

  test "delete_answer/1" do
    answer = setup_answer()

    deleted_answer = delete_answer(answer.id)

    assert deleted_answer.deleted_at
  end

  defp setup_answer do
    insert(:answer, %{user_id: @user_id}) |> reset_fields([:card])
  end

  defp setup_card do
    insert(:card, %{user_id: @user_id})
  end

  defp load_answers(card_id) do
    Answers.list_answers(%{"user_id" => @user_id, "card_id" => card_id})
  end

  defp load_answer(id) do
    Answers.get_answer(%{"id" => id, "user_id" => @user_id})
  end

  defp create_answer(card_id, data) do
    Answers.create_answer(%{"user_id" => @user_id, "card_id" => card_id}, data)

    case Answers.list_answers(%{"user_id" => @user_id, "card_id" => card_id}) do
      [] -> nil
      [created_answer] -> created_answer
      [created_answer | _] -> created_answer
    end
  end

  defp update_answer(id, data) do
    Answers.update_answer(%{"id" => id, "user_id" => @user_id}, data)
    Answers.get_answer(%{"id" => id, "user_id" => @user_id})
  end

  defp delete_answer(id) do
    {:ok, answer} = Answers.delete_answer(%{"id" => id, "user_id" => @user_id})
    answer
  end
end
