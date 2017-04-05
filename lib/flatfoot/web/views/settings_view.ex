defmodule Flatfoot.Web.SettingsView do
  use Flatfoot.Web, :view
  alias Flatfoot.Web.SettingsView

  def render("show.json", %{settings: settings}) do
    %{data: render_one(settings, SettingsView, "settings.json")}
  end

  def render("settings.json", %{settings: settings}) do
    %{
      id: settings.id,
      global_threshold: settings.global_threshold,
      user_id: settings.user_id
    }
  end
end
