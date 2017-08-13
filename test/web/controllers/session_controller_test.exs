defmodule FlatfootWeb.SessionControllerTest do
  use FlatfootWeb.ConnCase

  alias Flatfoot.Clients

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(Flatfoot.Router, :api)

    password = "password"
    {:ok, user} = Clients.create_user(%{username: Faker.Internet.user_name, email: Faker.Internet.email, password: password})

    {:ok, %{conn: conn, user: user, password: password}}
  end

  describe "POST create" do
    test "creates new session with valid attributes", %{conn: conn, user: user, password: password} do
      conn = post conn, session_path(conn, :create), user_params: %{username: user.username, password: password}

      assert %{"data" => result} = json_response(conn, 201)
      assert result["token"] |> String.length == 32
    end

    test "returns error with invalid password", %{conn: conn, user: user} do
      conn = post conn, session_path(conn, :create), user_params: %{username: user.username, password: "incorrect"}
      assert json_response(conn, 401)["errors"] == "Unauthorized, password was incorrect"
    end

    test "returns error with invalid user", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user_params: %{username: "not_real_name", password: "password"}
      assert json_response(conn, 401)["errors"] == "Unauthorized, user does not exist"
    end
  end

  describe "GET get_ws_token" do
    setup :login_user_setup

    test "returns valid websocket token", %{logged_in: conn} do
      conn = get conn, session_path(conn, :get_ws_token)
      assert %{"token" => _} = json_response(conn, 200)
    end

    test "does not return a token if not logged in", %{not_logged_in: conn} do
      conn = get conn, session_path(conn, :get_ws_token)
      assert conn.status == 401
      assert conn.halted
    end
  end
end
