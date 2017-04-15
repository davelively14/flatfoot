defmodule Flatfoot.Web.SuspectAccountView do
  use Flatfoot.Web, :view

  # Requires backend to be preloaded.
  def render("suspect_account.json", %{suspect_account: suspect_account}) do
    %{
      id: suspect_account.id,
      handle: suspect_account.handle,
      network: suspect_account.backend.name
    }
  end
end
