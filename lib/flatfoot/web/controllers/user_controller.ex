defmodule Flatfoot.Web.UserController do
  use Flatfoot.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Flatfoot.Clients
  alias Flatfoot.Clients.User

  action_fallback Flatfoot.Web.FallbackController

  def index(conn, _params) do
    users = Clients.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user_params" => user_params}) do
    with {:ok, %User{} = user} <- Clients.create_user(user_params) do
      {:ok, session} = Clients.login(%{user_id: user.id})

      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render(Flatfoot.Web.SessionView, "show.json", session: session)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Clients.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user_params" => user_params}) do
    user = Clients.get_user!(id)

    if user_params["current_password"] && user_params["new_password"] do

      cond do
        checkpw(user_params["current_password"], user.password_hash) ->
          user_params = user_params |> Map.merge(%{"password" => user_params["new_password"]})
          with {:ok, %User{} = user} <- Clients.update_user_and_password(user, user_params) do
            render(conn, "show.json", user: user)
          end
        true ->
          render(conn |> put_status(401), Flatfoot.Web.ErrorView, "error.json", error: "Current password is invalid.")
      end
    else
      with {:ok, %User{} = user} <- Clients.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Clients.get_user!(id)
    with {:ok, %User{}} <- Clients.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
