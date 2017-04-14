defmodule Flatfoot.Web.WatchlistView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.WatchlistView

  # Requires suspects to be preloaded
  def render("watchlist.json", %{watchlist: watchlist}) do
    %{
      id: watchlist.id,
      name: watchlist.name,
      user_id: watchlist.user_id,
      suspects: render_many(watchlist.suspects, WatchlistView, "suspect.json")
    }
  end

  # TODO do we need this? To preven prelaoding? Or should we just preload everything for a user?
  def render("suspect.json", %{suspect: suspect}) do
    %{
      id: suspect.id,
      name: suspect.name,
      category: suspect.category,
      notes: suspect.notes,
      active: suspect.active,
      watchlist_id: suspect.watchlist_id
    }
  end
end
