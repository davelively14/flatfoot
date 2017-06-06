defmodule Flatfoot.Web.WardView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.WardView

  def render("ward.json", %{ward: ward}) do
    %{
      id: ward.id,
      name: ward.name,
      relationship: ward.relationship,
      active: ward.active,
      user_id: ward.user_id
    }
  end

  def render("ward_preload.json", %{ward: ward}) do
    %{
      id: ward.id,
      name: ward.name,
      relationship: ward.relationship,
      active: ward.active,
      user_id: ward.user_id,
      ward_accounts: render_many(ward.ward_accounts, Flatfoot.Web.WardAccountView, "ward_account_preloaded_backend.json")
    }
  end

  def render("ward_list.json", %{wards: wards}) do
    %{
      wards: render_many(wards, WardView, "ward.json")
    }
  end
end
