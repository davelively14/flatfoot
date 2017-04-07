defmodule Flatfoot.Web.BlackoutOptionController do
  use Flatfoot.Web, :controller

  alias Flatfoot.{Clients, Clients.BlackoutOption}

  action_fallback Flatfoot.Web.FallbackController

  def index(conn, %{"settings_id" => settings_id}) do
    settings = Clients.get_settings!(settings_id)

    if authorized?(conn, settings) do
      blackout_options = Clients.list_blackout_options(settings.id)
      render(conn, "index.json", %{blackout_options: blackout_options})
    else
      conn |> render_unauthorized
    end
  end

  def show(conn, %{"id" => id}) do
    blackout_option = Clients.get_blackout_option!(id)

    if authorized?(conn, blackout_option) do
      render(conn, "show.json", blackout_option: blackout_option)
    else
      conn |> render_unauthorized
    end
  end

  def create(conn, %{"params" => params}) do
    with {:ok, %BlackoutOption{} = blackout_option} <- Clients.create_blackout_option(params) do
      conn
      |> put_status(:created)
      |> render("show.json", blackout_option: blackout_option)
    end
  end

  #####################
  # Private Functions #
  #####################

  # Checks to see if the given record's owner is the same as the current_user
  defp authorized?(conn, record), do: record |> Clients.owner_id == conn.assigns.current_user.id
  defp render_unauthorized(conn), do: conn |> put_status(401) |> render("error.json", error: "Unauthorized. Can not view or edit content for another user.")
end
