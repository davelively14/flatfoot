defmodule Flatfoot.Web.UserControllerTest do
  use Flatfoot.Web.ConnCase

  alias Flatfoot.{Clients.User, Repo}

  @username Faker.Internet.user_name
  @email Faker.Internet.free_email
  @password Faker.Code.isbn
  @new_email Faker.Internet.free_email

  @create_attrs %{email: @email, password: @password, username: @username}

  describe "GET index" do
    test "renders a list of a single user" do
      conn = build_conn()
      user = insert(:user)

      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200) == render_json("index.json", users: [user])
    end

    test "renders a list of multiple users" do
      conn = build_conn()
      for _ <- 1..10 do insert(:user) end
      users = User |> Repo.all

      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200) == render_json("index.json", users: users)
    end
  end

  describe "POST create" do
    test "creates user and renders user when data is valid" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user: @create_attrs

      # Assigns the id from the response to the variable id during the match
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => @email,
        "username" => @username
      }
    end

    test "does not create user with no email" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user: %{username: @username, password: @password}
      assert json_response(conn, 422)["errors"] == %{"email" => ["can't be blank"]}
    end

    test "does not create user with no username" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user: %{email: @email, password: @password}
      assert json_response(conn, 422)["errors"] == %{"username" => ["can't be blank"]}
    end

    test "does not create user with no password" do
      conn = build_conn()

      conn = post conn, user_path(conn, :create), user: %{email: @email, username: @username }
      assert json_response(conn, 422)["errors"] == %{"password" => ["can't be blank"]}
    end
  end

  describe "PUT update" do
    test "updates user and renders user data when valid" do
      conn = build_conn()
      user = insert(:user)

      conn = put conn, user_path(conn, :update, user), user: %{email: @new_email}
      assert json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, User |> Repo.get_by!(email: @new_email))
      assert json_response(conn, 200)["data"]["email"] == @new_email
    end

    test "does not update chosen user and renders errors when data is invalid" do
      conn = build_conn()
      user = insert(:user)

      conn = put conn, user_path(conn, :update, user), user: %{username: "", email: ""}
      assert json_response(conn, 422)["errors"] == %{"username" => ["can't be blank"], "email" => ["can't be blank"]}
    end
  end

  describe "DELETE delete" do
    test "deletes chosen user" do
      conn = build_conn()
      user = insert(:user)

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
