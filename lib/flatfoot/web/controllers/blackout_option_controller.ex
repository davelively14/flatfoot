defmodule Flatfoot.Web.BlackoutOptionController do
  use Flatfoot.Web, :controller

  alias Flatfoot.{Clients}

  action_fallback Flatfoot.Web.FallbackController

  def index(conn, %{"settings_id" => settings_id}) do
    settings = Clients.get_settings!(settings_id)
    blackout_options = Clients.list_blackout_options(settings_id)

    cond do
      settings.user_id != conn.assigns.current_user.id ->
        conn
        |> put_status(401)
        |> render("error.json", error: "Unauthorized. Can only view your own settings.")
      true ->
        render(conn, "index.json", blackout_options: blackout_options)
    end
  end
end
