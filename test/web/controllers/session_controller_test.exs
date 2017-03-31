defmodule Flatfoot.Web.SessionControllerTest do
  use Flatfoot.Web.ConnCase

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

      assert %{"user_id" => user_id} = json_response(conn, 201)["data"]
      assert user_id == user.id
    end
  end
end
