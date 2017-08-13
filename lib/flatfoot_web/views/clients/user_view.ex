defmodule FlatfootWeb.UserView do
  use FlatfootWeb, :view
  alias FlatfootWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      global_threshold: user.global_threshold,
      email: user.email
    }
  end

  def render("error.json", _) do
    %{errors: "Failed to authenticate"}
  end

  def render("authorized.json", %{}) do
    %{
      authorized: true
    }
  end

  def render("unauthorized.json", %{error: error}) do
    %{
      authorized: false,
      error: error
    }
  end
end
