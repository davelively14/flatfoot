defmodule Flatfoot.Web.WardAccountView do
  use Flatfoot.Web, :view

  def render("ward_account.json", %{ward_account: ward_account}) do
    %{
      id: ward_account.id,
      handle: ward_account.handle,
      network: ward_account.backend.name,
      backend_module: ward_account.backend.module
    }
  end
end
