defmodule FlatfootWeb.UserController do
  use FlatfootWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Flatfoot.Clients
  alias Flatfoot.Clients.User

  action_fallback FlatfootWeb.FallbackController

  def index(conn, _params) do
    users = Clients.list_users()
    render(conn, "index.json", users: users)
  end

  # NOTE: deleted put_resp_header - no idea what it was used for.
  def create(conn, %{"user_params" => user_params}) do
    with {:ok, %User{} = user} <- Clients.create_user(user_params) do
      {:ok, session} = Clients.login(%{user_id: user.id})

      conn
      |> put_status(:created)
      # |> put_resp_header("location", user_path(conn, :show, user))
      |> render(FlatfootWeb.SessionView, "show.json", session: session)
    end
  end

  def show(conn, %{"token" => token}) do
    user = Clients.get_user_by_token(token)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"token" => token, "user_params" => user_params}) do
    user = Clients.get_user_by_token(token)

    if user_params["current_password"] && user_params["new_password"] do

      cond do
        checkpw(user_params["current_password"], user.password_hash) ->
          user_params = user_params |> Map.merge(%{"password" => user_params["new_password"]})
          with {:ok, %User{} = user} <- Clients.update_user_and_password(user, user_params) do
            render(conn, "show.json", user: user)
          end
        true ->
          render(conn |> put_status(401), FlatfootWeb.ErrorView, "error.json", error: "Current password is invalid.")
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

  def validate_user(conn, %{"username" => username, "password" => password}) do
    user = Clients.get_user_by_username(username)

    cond do
      user && checkpw(password, user.password_hash) ->
        conn
        |> render("authorized.json", %{})
      user ->
        conn
        |> render("unauthorized.json", error: "password was incorrect")
      true ->
        dummy_checkpw()
        conn
        |> render("unauthorized.json", error: "username does not exist")
    end
  end
end
