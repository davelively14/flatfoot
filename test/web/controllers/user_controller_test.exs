defmodule FlatfootWeb.UserControllerTest do
  use FlatfootWeb.ConnCase

  alias Flatfoot.{Clients.User, Repo, Clients}

  @username Faker.Internet.user_name
  @email Faker.Internet.free_email
  @password Faker.Code.isbn
  @global_threshold Enum.random(0..100)
  @new_email Faker.Internet.free_email

  @create_attrs %{email: @email, password: @password, username: @username, global_threshold: @global_threshold}

  describe "GET index" do
    setup [:login_user_setup]

    test "renders a list of a single user", %{logged_in: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200) == render_json("index.json", users: [conn.assigns.current_user])
    end

    test "renders a list of multiple users", %{logged_in: conn} do
      for _ <- 1..10 do insert(:user) end
      users = User |> Repo.all

      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200) == render_json("index.json", users: users)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      conn = get conn, user_path(conn, :index)
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "GET show" do
    setup [:login_user_setup]

    test "with a valid token, renders a single user", %{not_logged_in: conn, logged_in: logged_in_conn, token: token} do
      conn = get conn, user_path(conn, :show), token: token
      assert json_response(conn, 200) == render_json("show.json", user: logged_in_conn.assigns.current_user)
    end

    test "with invalid token, returns a JSON object with data set to nil", %{not_logged_in: conn} do
      conn = get conn, user_path(conn, :show), token: "123"
      assert json_response(conn, 200) == render_json("show.json", user: nil)
    end
  end

  describe "POST create" do
    test "creates user when data is valid" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: @create_attrs

      # Assigns the id from the response to the variable id during the match
      assert %{"token" => token} = json_response(conn, 201)["data"]
      user = Clients.get_user_by_token(token)
      assert user.username == @username
      assert user.email == @email
      assert user.global_threshold == @global_threshold
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

      conn = post conn, user_path(conn, :create), user_params: %{email: @email, username: @username}
      assert json_response(conn, 422)["errors"] == %{"password" => ["can't be blank"]}
    end

    test "does not create user with a global_threshold outside of the range" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user_params: %{email: @email, password: @password, username: @username, global_threshold: 101}
      assert json_response(conn, 422)["errors"] == %{"global_threshold" => ["is invalid"]}
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
    setup [:login_user_setup]

    test "updates user and renders user data when valid", %{logged_in: conn, token: token} do
      user = conn.assigns.current_user
      local_conn = put conn, user_path(conn, :update), token: token, user_params: %{email: @new_email}

      assert %{"data" => updated_user} = json_response(local_conn, 200)
      assert updated_user["username"] == user.username
      assert updated_user["id"] == user.id
      assert updated_user["email"] == @new_email
    end

    test "does not update chosen user and renders errors when data is invalid", %{logged_in: conn, token: token} do
      conn = put conn, user_path(conn, :update), token: token, user_params: %{username: "", email: "", global_threshold: -21}
      assert json_response(conn, 422)["errors"] == %{"username" => ["can't be blank"], "email" => ["can't be blank"], "global_threshold" => ["is invalid"]}
    end

    test "will accept and update password when old password is provided", %{logged_in: conn, password: password, token: token} do
      new_password = "newpassword"
      user = conn.assigns.current_user
      conn = put conn, user_path(conn, :update), token: token, user_params: %{current_password: password, new_password: new_password}
      assert conn.status == 200

      conn = post conn, session_path(conn, :create), user_params: %{username: user.username, password: new_password}
      assert conn.status == 201
    end

    test "will return an error when attempting to change password with an incorrect current password", %{logged_in: conn, token: token} do
      new_password = "newpassword"
      conn = put conn, user_path(conn, :update), token: token, user_params: %{current_password: "not correct", new_password: new_password}
      assert %{"errors" => "Current password is invalid."} = json_response(conn, 401)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn, token: token} do
      conn = put conn, user_path(conn, :update), token: token, user_params: %{email: @new_email}
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "DELETE delete" do
    setup [:login_user_setup]

    test "deletes chosen user", %{logged_in: conn} do
      conn = delete conn, user_path(conn, :delete, conn.assigns.current_user)
      assert response(conn, 204)
      assert User |> Repo.all |> length == 0
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      user = insert(:user)
      conn = delete conn, user_path(conn, :delete, user)
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "GET validate_user" do
    setup [:login_user_setup]

    test "with valid username and password, returns true", %{logged_in: conn, password: password} do
      conn = get conn, user_path(conn, :validate_user), %{username: conn.assigns.current_user.username, password: password}
      assert json_response(conn, 200) == %{"authorized" => true}
    end

    test "with valid username and invalid password, returns false with error", %{logged_in: conn} do
      conn = get conn, user_path(conn, :validate_user), %{username: conn.assigns.current_user.username, password: "11111"}
      assert json_response(conn, 200) == %{"authorized" => false, "error" => "password was incorrect"}
    end

    test "with invalid username, returns false with error", %{logged_in: conn, password: password} do
      conn = get conn, user_path(conn, :validate_user), %{username: "not_a_real_name", password: password}
      assert json_response(conn, 200) == %{"authorized" => false, "error" => "username does not exist"}
    end
  end

  #####################
  # Private Functions #
  #####################

  defp render_json(template, assigns) do
    assigns = Map.new(assigns)

    FlatfootWeb.UserView.render(template, assigns)
    |> Poison.encode!
    |> Poison.decode!
  end
end
