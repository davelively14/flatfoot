defmodule FlatfootWeb.SessionController do
  use FlatfootWeb, :controller

  alias Flatfoot.{Clients, Clients.Session}

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  action_fallback FlatfootWeb.FallbackController

  def create(conn, %{"user_params" => user_params}) do
    user = Clients.get_user_by_username(user_params["username"])

    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        with {:ok, %Session{} = session} <- Clients.login(%{user_id: user.id}) do
          conn
          |> put_status(:created)
          |> render("show.json", session: session)
        end
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "password was incorrect")
      true ->
        dummy_checkpw()
        conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "user does not exist")
    end
  end

  def get_ws_token(conn, _) do
    conn
    |> put_status(200)
    |> render("token.json", token: conn.assigns.ws_token)
  end
end
