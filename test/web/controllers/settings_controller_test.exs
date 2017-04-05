defmodule Flatfoot.Web.SettingsControllerTest do
  use Flatfoot.Web.ConnCase

  setup [:login_user_setup]

  describe "GET show" do
    test "renders a settings with a valid user_id", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)

      conn = get conn, settings_path(conn, :show)
      assert %{"data" => result} = json_response(conn, 200)

      assert result["user_id"] == settings.user_id
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      insert(:settings)

      conn = get conn, settings_path(conn, :show)
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "POST create" do
    test "with valid attributes will create settings", %{logged_in: conn} do
      conn = post conn, settings_path(conn, :create), params: %{global_threshold: 50}
      assert %{"data" => settings} = json_response(conn, 201)

      assert settings["user_id"] == conn.assigns.current_user.id
      assert settings["global_threshold"] == 50
    end

    test "with invalid attributes will not create settings", %{logged_in: conn} do
      conn = post conn, settings_path(conn, :create), params: %{global_threshold: "invalid"}
      assert %{"errors" => error} = json_response(conn, 422)
      assert error["global_threshold"] == ["is invalid"]
    end

    test "will ignore a user_id for another user", %{logged_in: conn} do
      user = insert(:user)
      conn = post conn, settings_path(conn, :create), params: %{global_threshold: 50, user_id: user}
      assert %{"data" => settings} = json_response(conn, 201)

      assert settings["user_id"] != user.id
      assert settings["user_id"] == conn.assigns.current_user.id
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      user = insert(:user)
      conn = post conn, settings_path(conn, :create), params: %{global_threshold: 50, user_id: user.id}
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "PUT update" do
    test "with valid attributes will update settings", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user, global_threshold: 0)

      conn = put conn, settings_path(conn, :update), params: %{global_threshold: 50}
      assert %{"data" => result} = json_response(conn, 200)
      assert settings.global_threshold == 0
      assert result["global_threshold"] == 50
      assert settings.id == result["id"]
    end

    test "with invalid attribute raises error", %{logged_in: conn} do
      insert(:settings, user: conn.assigns.current_user)

      conn = put conn, settings_path(conn, :update), params: %{global_threshold: "wrong"}
      assert %{"errors" => error} = json_response(conn, 422)
      assert error["global_threshold"] == ["is invalid"]
    end

    test "cannot change user_id", %{logged_in: conn} do
      user = conn.assigns.current_user
      insert(:settings, user: user)

      conn = put conn, settings_path(conn, :update), params: %{user_id: 0}
      assert %{"data" => result} = json_response(conn, 200)
      assert result["user_id"] != 0
      assert result["user_id"] == user.id
    end
  end
end
