defmodule Flatfoot.Clients.AuthTest do
  use Flatfoot.Web.ConnCase
  alias Flatfoot.Clients.Auth

  @opts Auth.init([])

  test "finds the user with valid token", %{conn: conn} do
    session = insert(:session)

    conn =
      conn
      |> put_auth_token_in_header(session.token)
      |> Auth.call(@opts)

    assert conn.assigns.current_user
  end

  test "returns 401 status when passed invalid token", %{conn: conn} do
    conn =
      conn
      |> put_auth_token_in_header("foo")
      |> Auth.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "returns 401 status when passed no token", %{conn: conn} do
    conn = Auth.call(conn, @opts)

    assert conn.status == 401
    assert conn.halted
  end

  #####################
  # Private Functions #
  #####################

  defp put_auth_token_in_header(conn, token) do
    conn |> put_req_header("authorization", "Token token =\"#{token}\"")
  end
end
