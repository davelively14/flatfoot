defmodule Flatfoot.Web.UserControllerTest do
  use Flatfoot.Web.ConnCase

  alias Flatfoot.{Clients.User, Repo}

  @username Faker.Internet.user_name
  @email Faker.Internet.free_email
  @password Faker.Code.isbn
  @new_email Faker.Internet.free_email

  @create_attrs %{email: @email, password: @password, username: @username}

  setup %{conn: conn} do
    user = insert(:user, password_hash: Comeonin.Bcrypt.hashpwsalt("password"))
    session = insert(:session, user: user)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Token token=\"#{session.token}\"")

    {:ok, conn: conn, current_user: user}
  end

  describe "GET index" do
    test "renders a list of a single user", %{conn: conn, current_user: current_user} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200) == render_json("index.json", users: [current_user])
    end

    test "renders a list of multiple users", %{conn: conn} do
      for _ <- 1..10 do insert(:user) end
      users = User |> Repo.all

      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200) == render_json("index.json", users: users)
    end
  end

  describe "POST create" do
    test "creates user and renders user when data is valid" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: @create_attrs

      # Assigns the id from the response to the variable id during the match
      assert %{"id" => id} = json_response(conn, 201)["data"]
      user = User |> Repo.get(id)
      assert user.username == @username
      assert user.email == @email
    end

    test "does not create user with no email" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: %{username: @username, password: @password}
      assert json_response(conn, 422)["errors"] == %{"email" => ["can't be blank"]}
    end

    test "does not create user with no username" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: %{email: @email, password: @password}
      assert json_response(conn, 422)["errors"] == %{"username" => ["can't be blank"]}
    end

    test "does not create user with no password" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: %{email: @email, username: @username }
      assert json_response(conn, 422)["errors"] == %{"password" => ["can't be blank"]}
    end

    test "only accepts valid email address" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: %{username: @username, password: @password, email: "jon@com"}
      assert json_response(conn, 422)["errors"] == %{"email" => ["has invalid format"]}

      conn = post conn, user_path(conn, :create), user_params: %{username: @username, password: @password, email: "jon@.com"}
      assert json_response(conn, 422)["errors"] == %{"email" => ["has invalid format"]}

      conn = post conn, user_path(conn, :create), user_params: %{username: @username, password: @password, email: "gmail.com"}
      assert json_response(conn, 422)["errors"] == %{"email" => ["has invalid format"]}

      conn = post conn, user_path(conn, :create), user_params: %{username: @username, password: @password, email: "j@gmail.com"}
      assert json_response(conn, 201)
    end
  end

  describe "PUT update" do
    test "updates user and renders user data when valid", %{conn: conn, current_user: user} do
      local_conn = put conn, user_path(conn, :update, user), user_params: %{email: @new_email}
      assert json_response(local_conn, 200)["data"]

      local_conn = get conn, user_path(conn, :show, User |> Repo.get_by!(email: @new_email))
      assert json_response(local_conn, 200)["data"]["email"] == @new_email
    end

    test "does not update chosen user and renders errors when data is invalid", %{conn: conn, current_user: user} do
      conn = put conn, user_path(conn, :update, user), user_params: %{username: "", email: ""}
      assert json_response(conn, 422)["errors"] == %{"username" => ["can't be blank"], "email" => ["can't be blank"]}
    end
  end

  describe "DELETE delete" do
    test "deletes chosen user", %{conn: conn, current_user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert User |> Repo.all |> length == 0
    end

  end


  #####################
  # Private Functions #
  #####################

  defp render_json(template, assigns) do
    assigns = Map.new(assigns)

    Flatfoot.Web.UserView.render(template, assigns)
    |> Poison.encode!
    |> Poison.decode!
  end
end
