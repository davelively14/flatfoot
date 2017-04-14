defmodule Flatfoot.Web.SuspectView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.SuspectView

  # Requires suspect_accounts to be preloaded
  def render("suspect.json", %{suspect: suspect}) do
    %{
      id: suspect.id,
      name: suspect.name,
      category: suspect.category,
      notes: suspect.notes,
      active: suspect.active,
      watchlist_id: suspect.watchlist_id,
      suspect_accounts: render_many(suspect.suspect_accounts, Flatfoot.Web.SuspectAccountView, "suspect_account.json")
    }
  end

  def render("suspect_list.json", %{suspects: suspects}) do
    %{
      suspects: render_many(suspects, SuspectView, "suspect.json")
    }
  end
end
