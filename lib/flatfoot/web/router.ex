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
  end

  scope "/api", Flatfoot.Web do
    pipe_through [:api, :authenticate]

    resources "/users", UserController, only: [:index, :show, :update, :delete]
    resources "/notification_records", NotificationRecordController, only: [:create, :index, :show, :update, :delete]

    resources "/settings", SettingsController, only: [:create]
    get "/settings", SettingsController, :show
    put "/settings", SettingsController, :update

    resources "/blackout_options", BlackoutOptionController, only: [:index, :show, :create]
  end
end
