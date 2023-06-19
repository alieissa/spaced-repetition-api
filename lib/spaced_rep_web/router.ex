defmodule SpacedRepWeb.Router do
  use SpacedRepWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SpacedRepWeb do
    pipe_through :api

    resources "/decks", DeckController, except: [:new, :edit] do
      resources "/cards", CardController, except: [:new, :edit] do
        resources "/answers", AnswerController, except: [:new, :edit]
      end
    end
  end
end
