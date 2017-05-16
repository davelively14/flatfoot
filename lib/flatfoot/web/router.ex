defmodule Flatfoot.Web.Router do
  use Flatfoot.Web, :router

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

  scope "/", Flatfoot.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Flatfoot.Web do
    pipe_through :api

    resources "/login", SessionController, only: [:create]
    resources "/new_user", UserController, only: [:create]
    get "/users/token", UserController, :show
  end

  scope "/api", Flatfoot.Web do
    pipe_through [:api, :authenticate]

    get "/token", SessionController, :get_ws_token

    resources "/users", UserController, only: [:index, :update, :delete]
    resources "/notification_records", NotificationRecordController, only: [:create, :index, :show, :update, :delete]

    resources "/settings", SettingsController, only: [:create]
    get "/settings", SettingsController, :show
    put "/settings", SettingsController, :update

    resources "/blackout_options", BlackoutOptionController, only: [:index, :show, :create, :update, :delete]
  end

  # Want every other path to go back to root. This allows React router to handle
  # nested urls via links.
  scope "/*path", Flatfoot.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
