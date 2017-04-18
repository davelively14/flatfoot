defmodule Flatfoot.Web.Spade.UserView do
  use Flatfoot.Web, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      watchlists: render_many(user.watchlists, Flatfoot.Web.WatchlistView, "watchlist.json"),
      wards: render_many(user.wards, Flatfoot.Web.WardView, "ward.json")
    }
  end
end
