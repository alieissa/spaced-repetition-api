defmodule SpacedRepWeb.Router do
  use SpacedRepWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SpacedRepWeb do
    pipe_through :api

    post "decks/:deck_id/cards/:card_id/answers/check", AnswerController, :check
    # TODO Unnest routes
    resources "decks", DeckController, except: [:new, :edit] do
      resources "cards", CardController, except: [:new, :edit] do
        resources "answers", AnswerController, except: [:new, :edit]
      end
    end
  end
end
