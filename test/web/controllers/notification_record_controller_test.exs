defmodule Flatfoot.Web.NotificationRecordControllerTest do
  use Flatfoot.Web.ConnCase

  setup [:login_user_setup]

  describe "POST create" do
    test "creates new NotificationRecord with valid attributes", %{conn: conn} do
      user = conn.assigns.current_user
      nickname = Faker.Name.name
      email = Faker.Internet.free_email

      conn = post conn, notification_record_path(conn, :create), params: %{user_id: user.id, nickname: nickname, email: email}
      assert %{"data" => record} = json_response(conn, 201)

      assert record["user_id"] == user.id
      assert record["nickname"] == nickname
      assert record["email"] == email
    end

    test "with invalid attributes", %{conn: conn} do
      conn = post conn, notification_record_path(conn, :create), params: %{user_id: nil, nickname: nil, email: nil}
      assert %{"errors" => errors} = json_response(conn, 422)

      assert errors["user_id"] == ["can't be blank"]
      assert errors["nickname"] == ["can't be blank"]
      assert errors["email"] == ["can't be blank"]
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      user = insert(:user)
      nickname = Faker.Name.name
      email = Faker.Internet.free_email

      conn = post conn, notification_record_path(conn, :create), params: %{user_id: user.id, nickname: nickname, email: email}
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "GET index" do
    test "renders a list of notification records for current_user", %{conn: conn} do
      original_records = insert_list(5, :notification_record, user: conn.assigns.current_user)
      insert_list(5, :notification_record)

      conn = get conn, notification_record_path(conn, :index)
      assert %{"data" => results} = json_response(conn, 200)
      assert results |> length == original_records |> length
    end

    test "will not produce notification records for other users", %{conn: conn} do
      user = insert(:user)
      insert_list(5, :notification_record, user: user)

      conn = get conn, notification_record_path(conn, :index)
      assert %{"data" => results} = json_response(conn, 200)
      assert results == []
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      user = insert(:user)
      insert_list(5, :notification_record, user: user)
      insert_list(5, :notification_record)

      conn = get conn, notification_record_path(conn, :index)
      assert conn.status == 401
      assert conn.halted
    end
  end
end
