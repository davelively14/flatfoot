defmodule Flatfoot.Authorize do
  import Flatfoot.Factory
  import Phoenix.ConnTest, only: [bypass_through: 3, build_conn: 0]
  import Plug.Conn, only: [put_req_header: 3, assign: 3]
  alias Flatfoot.Clients

  @password "password"

  def login(conn, user \\ nil) do
    user = if !user, do: insert(:user, password_hash: Comeonin.Bcrypt.hashpwsalt(@password)), else: user
    {:ok, session} = Clients.login(%{user_id: user.id})

    conn
    |> put_req_header("authorization", "Token token=\"#{session.token}\"")
    |> assign(:current_user, user)
    |> assign(:token, session.token)
  end

  def login_user_setup(context) do
    conn = if Map.has_key?(context, :conn), do: context.conn, else: build_conn()
    conn =
      conn
      |> bypass_through(Flatfoot.Router, :api)
      |> login

    not_logged_in = build_conn()

    {:ok, %{logged_in: conn, not_logged_in: not_logged_in, password: @password, token: conn.assigns.token}}
  end
end
