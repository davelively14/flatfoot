defmodule Flatfoot.Web.SessionController do
  use Flatfoot.Web, :controller

  alias Flatfoot.{Clients, Clients.Session}

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  action_fallback Flatfoot.Web.FallbackController

  def create(conn, %{"user_params" => user_params}) do
    user = Clients.get_user_by_username(user_params["username"])

    cond do
      user && checkpw(user_params["password"], user.password_hash) ->
        with {:ok, %Session{} = session} <- Clients.create_session(%{user_id: user.id}) do
          conn
          |> put_status(:created)
          |> render("show.json", session: session)
        end
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw()
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end
end
