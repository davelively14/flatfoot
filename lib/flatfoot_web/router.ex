defmodule FlatfootWeb.Router do
  use FlatfootWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug Flatfoot.Clients.Auth
  end

  scope "/", FlatfootWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", FlatfootWeb do
    pipe_through :api

    resources "/login", SessionController, only: [:create]
    resources "/new_user", UserController, only: [:create]
    get "/users/token", UserController, :show
  end

  scope "/api", FlatfootWeb do
    pipe_through [:api, :authenticate]

    get "/token", SessionController, :get_ws_token

    resources "/users", UserController, only: [:index, :delete]
    put "/users", UserController, :update
    patch "/users", UserController, :update
    get "/users/validate", UserController, :validate_user
    resources "/notification_records", NotificationRecordController, only: [:create, :index, :show, :update, :delete]

    resources "/blackout_options", BlackoutOptionController, only: [:index, :show, :create, :update, :delete]
  end

  # Want every other path to go back to root. This allows React router to handle
  # nested urls via links.
  scope "/*path", FlatfootWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
