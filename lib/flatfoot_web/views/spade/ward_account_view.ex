defmodule FlatfootWeb.WardAccountView do
  use FlatfootWeb, :view

  def render("ward_account_preloaded_backend.json", %{ward_account: ward_account}) do
    %{
      id: ward_account.id,
      ward_id: ward_account.ward_id,
      handle: ward_account.handle,
      last_msg: ward_account.last_msg,
      network: ward_account.backend.name,
      backend_module: ward_account.backend.module
    }
  end

  def render("ward_account.json", %{ward_account: ward_account}) do
    %{
      id: ward_account.id,
      ward_id: ward_account.ward_id,
      handle: ward_account.handle,
      last_msg: ward_account.last_msg,
      backend_id: ward_account.backend_id
    }
  end
end
