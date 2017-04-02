defmodule Flatfoot.Web.UserController do
  use Flatfoot.Web, :controller

  alias Flatfoot.Clients
  alias Flatfoot.Clients.User

  action_fallback Flatfoot.Web.FallbackController

  def index(conn, _params) do
    users = Clients.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user_params" => user_params}) do
    with {:ok, %User{} = user} <- Clients.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Clients.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user_params" => user_params}) do
    user = Clients.get_user!(id)

    with {:ok, %User{} = user} <- Clients.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Clients.get_user!(id)
    with {:ok, %User{}} <- Clients.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
