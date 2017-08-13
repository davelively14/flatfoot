defmodule FlatfootWeb.WatchlistView do
  use FlatfootWeb, :view

  # Requires suspects to be preloaded
  def render("watchlist.json", %{watchlist: watchlist}) do
    %{
      id: watchlist.id,
      name: watchlist.name,
      user_id: watchlist.user_id,
      suspects: render_many(watchlist.suspects, FlatfootWeb.SuspectView, "suspect.json")
    }
  end
end
