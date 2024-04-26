defmodule SpacedRepWeb.Router do
  use SpacedRepWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/decks/:deck_id/cards/:card_id/answers", SpacedRepWeb do
    pipe_through :api
    get "/", AnswerController, :index
    post "/", AnswerController, :create
    get "/:id", AnswerController, :show
    put "/:id", AnswerController, :update
    delete "/:id", AnswerController, :delete
    post "/check", AnswerController, :check
  end

  scope "/decks/:deck_id/cards", SpacedRepWeb do
    pipe_through :api
    get "/", CardController, :index
    post "/", CardController, :create
    get "/:id", CardController, :show
    put "/:id", CardController, :update
    delete "/:id", CardController, :delete
  end

  scope "/decks", SpacedRepWeb do
    pipe_through :api

    get "/", DeckController, :index
    post "/", DeckController, :create
    post "/upload", DeckController, :upload
    get "/:id", DeckController, :show
    put "/:id", DeckController, :update
    delete "/:id", DeckController, :delete
  end
end
