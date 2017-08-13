defmodule FlatfootWeb.SessionView do
  use FlatfootWeb, :view
  alias FlatfootWeb.SessionView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("error.json", %{error: error}) do
    %{errors: "Unauthorized, #{error}"}
  end

  def render("session.json", %{session: session}) do
    %{
      token: session.token
    }
  end

  def render("token.json", %{token: token}) do
    %{
      token: token 
    }
  end
end
