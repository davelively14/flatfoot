defmodule FlatfootWeb.SuspectView do
  use FlatfootWeb, :view
  alias FlatfootWeb.SuspectView

  # Requires suspect_accounts to be preloaded
  def render("suspect.json", %{suspect: suspect}) do
    %{
      id: suspect.id,
      name: suspect.name,
      category: suspect.category,
      notes: suspect.notes,
      active: suspect.active,
      watchlist_id: suspect.watchlist_id,
      suspect_accounts: render_many(suspect.suspect_accounts, FlatfootWeb.SuspectAccountView, "suspect_account.json")
    }
  end

  def render("suspect_list.json", %{suspects: suspects}) do
    %{
      suspects: render_many(suspects, SuspectView, "suspect.json")
    }
  end
end
