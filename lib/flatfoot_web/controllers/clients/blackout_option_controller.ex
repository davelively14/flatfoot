defmodule FlatfootWeb.BlackoutOptionController do
  use FlatfootWeb, :controller

  alias Flatfoot.{Clients, Clients.BlackoutOption}

  action_fallback FlatfootWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    user = Clients.get_user!(user_id)

    if authorized?(conn, user.id) do
      blackout_options = Clients.list_blackout_options(user.id)
      render(conn, "index.json", %{blackout_options: blackout_options})
    else
      conn |> render_unauthorized
    end
  end

  def show(conn, %{"id" => id}) do
    blackout_option = Clients.get_blackout_option!(id)

    if authorized?(conn, blackout_option.user_id) do
      render(conn, "show.json", blackout_option: blackout_option)
    else
      conn |> render_unauthorized
    end
  end

  def create(conn, %{"params" => params}) do
    if params["user_id"] do
      user = Clients.get_user!(params["user_id"])

      if authorized?(conn, user.id) do
        with {:ok, %BlackoutOption{} = blackout_option} <- Clients.create_blackout_option(params) do
          conn
          |> put_status(:created)
          |> render("show.json", blackout_option: blackout_option)
        end
      else
        conn |> render_unauthorized
      end
    else
      with {:ok, %BlackoutOption{} = blackout_option} <- Clients.create_blackout_option(params) do
        conn
        |> put_status(:created)
        |> render("show.json", blackout_option: blackout_option)
      end
    end
  end

  def update(conn, %{"id" => id, "params" => params}) do
    blackout_option = Clients.get_blackout_option!(id)

    if authorized?(conn, blackout_option.user_id) do
      with {:ok, %BlackoutOption{} = blackout_option} <- Clients.update_blackout_option(blackout_option, params) do
        render(conn, "show.json", blackout_option: blackout_option)
      end
    else
      conn |> render_unauthorized
    end
  end

  def delete(conn, %{"id" => id}) do
    blackout_option = Clients.get_blackout_option!(id)

    if authorized?(conn, blackout_option.user_id) do
      with {:ok, %BlackoutOption{}} <- Clients.delete_blackout_option(blackout_option) do
        send_resp(conn, :no_content, "")
      end
    else
      conn |> render_unauthorized
    end
  end

  #####################
  # Private Functions #
  #####################

  # Checks to see if the given record's owner is the same as the current_user
  defp authorized?(conn, owner_id), do: owner_id == conn.assigns.current_user.id
  defp render_unauthorized(conn), do: conn |> put_status(401) |> render("error.json", error: "Unauthorized. Can not view or edit content for another user.")
end
