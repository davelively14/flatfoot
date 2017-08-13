defmodule FlatfootWeb.WardView do
  use FlatfootWeb, :view
  alias FlatfootWeb.WardView

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
      ward_accounts: render_many(ward.ward_accounts, FlatfootWeb.WardAccountView, "ward_account_preloaded_backend.json")
    }
  end

  def render("ward_list.json", %{wards: wards}) do
    %{
      wards: render_many(wards, WardView, "ward.json")
    }
  end
end
