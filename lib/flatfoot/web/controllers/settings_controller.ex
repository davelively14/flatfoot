defmodule Flatfoot.Web.SettingsController do
  use Flatfoot.Web, :controller

  alias Flatfoot.{Clients, Clients.Settings}

  action_fallback Flatfoot.Web.FallbackController

  def show(conn, _) do
    settings = Clients.get_settings!(conn.assigns.current_user.id)
    render(conn, "show.json", settings: settings)
  end

  def create(conn, %{"params" => params}) do
    params = params |> add_current_user_id(conn)

    with {:ok, %Settings{} = settings} <- Clients.create_settings(params) do
      conn
      |> put_status(:created)
      |> render("show.json", settings: settings)
    end
  end

  #####################
  # Private Functions #
  #####################

  defp add_current_user_id(params, conn), do: params |> Map.merge(%{"user_id" => conn.assigns.current_user.id})
end
