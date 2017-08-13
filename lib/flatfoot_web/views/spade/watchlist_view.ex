defmodule Flatfoot.Web.WatchlistView do
  use Flatfoot.Web, :view

  # Requires suspects to be preloaded
  def render("watchlist.json", %{watchlist: watchlist}) do
    %{
      id: watchlist.id,
      name: watchlist.name,
      user_id: watchlist.user_id,
      suspects: render_many(watchlist.suspects, Flatfoot.Web.SuspectView, "suspect.json")
    }
  end
end
