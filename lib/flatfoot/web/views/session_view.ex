defmodule Flatfoot.Web.SessionView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.SessionView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{
      id: session.id,
      token: session.token,
      user_id: session.user_id
    }
  end
end
