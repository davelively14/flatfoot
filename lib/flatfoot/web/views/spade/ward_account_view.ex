defmodule Flatfoot.Web.WardAccountView do
  use Flatfoot.Web, :view

  def render("ward_account.json", %{ward_account: ward_account}) do
    %{
      id: ward_account.id,
      ward_id: ward_account.ward_id,
      handle: ward_account.handle,
      network: ward_account.backend.name,
      backend_module: ward_account.backend.module
    }
  end

  def render("single_ward_account.json", %{ward_account: ward_account}) do
    %{
      id: ward_account.id,
      ward_id: ward_account.ward_id,
      handle: ward_account.handle,
      backend_id: ward_account.backend_id
    }
  end
end
