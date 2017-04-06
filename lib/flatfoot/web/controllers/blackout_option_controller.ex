defmodule Flatfoot.Web.BlackoutOptionController do
  use Flatfoot.Web, :controller

  alias Flatfoot.{Clients}

  action_fallback Flatfoot.Web.FallbackController

  def index(conn, %{"settings_id" => settings_id}) do
    blackout_options = Clients.list_blackout_options(settings_id)

    if blackout_options == [] do
      conn
      |> put_status(422)
      |> render("error.json", error: "Invalid settings_id")
    else
      render(conn, "index.json", blackout_options: blackout_options)
    end
  end
end
