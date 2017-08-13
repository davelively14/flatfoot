defmodule FlatfootWeb.Spade.UserView do
  use FlatfootWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      global_threshold: user.global_threshold,
      watchlists: render_many(user.watchlists, FlatfootWeb.WatchlistView, "watchlist.json"),
      wards: render_many(user.wards, FlatfootWeb.WardView, "ward_preload.json")
    }
  end
end
