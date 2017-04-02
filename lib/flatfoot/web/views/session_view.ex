defmodule Flatfoot.Web.SessionView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.SessionView

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
end
