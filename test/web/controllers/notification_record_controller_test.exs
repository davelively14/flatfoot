defmodule Flatfoot.Web.NotificationRecordControllerTest do
  use Flatfoot.Web.ConnCase

  describe "POST create, logged in token" do
    setup [:login_user_setup]

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
  end

  describe "POST create, no token" do
    test "creates new NotificationRecord with valid attributes", %{conn: conn} do
      user = insert(:user)
      nickname = Faker.Name.name
      email = Faker.Internet.free_email

      conn = post conn, notification_record_path(conn, :create), params: %{user_id: user.id, nickname: nickname, email: email}
      assert conn.status == 401
      assert conn.halted
    end
  end
end
