defmodule Flatfoot.Authorize do
  import Flatfoot.Factory
  import Plug.Conn, only: [put_req_header: 3, assign: 3]
  alias Flatfoot.Clients

  def login(conn) do
    user = insert(:user, password_hash: Comeonin.Bcrypt.hashpwsalt("password"))
    {:ok, session} = Clients.login(%{user_id: user.id})

    conn
    |> put_req_header("authorization", "Token token=\"#{session.token}\"")
    |> assign(:current_user, user)
  end
end
