defmodule Flatfoot.Web.BlackoutOptionControllerTest do
  use Flatfoot.Web.ConnCase

  # alias Flatfoot.Clients.BlackoutOption

  setup [:login_user_setup]

  describe "GET index" do
    test "renders a list of blackout options with valid settings_id", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      insert_list(3, :blackout_option, settings: settings)
      insert_list(2, :blackout_option)

      conn = get conn, blackout_option_path(conn, :index), %{settings_id: settings.id}
      assert %{"data" => results} = json_response(conn, 200)
      assert results |> length == 3
    end

    test "with invalid settings_id returns error", %{logged_in: conn} do
      assert_raise Ecto.NoResultsError, fn -> get conn, blackout_option_path(conn, :index), %{settings_id: 0} end
    end

    test "returns empty list if settings has no blackout options", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      conn = get conn, blackout_option_path(conn, :index), %{settings_id: settings.id}
      assert %{"data" => []} = json_response(conn, 200)
    end

    test "cannot view other users blackout options", %{logged_in: conn} do
      insert(:settings, user: conn.assigns.current_user)
      settings = insert(:settings)
      conn = get conn, blackout_option_path(conn, :index), %{settings_id: settings.id}
      assert %{"errors" => "Unauthorized. Can only view your own settings."} == json_response(conn, 401)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      settings = insert(:settings)
      insert_list(3, :blackout_option, settings: settings)

      conn = get conn, blackout_option_path(conn, :index), %{settings_id: settings.id}
      assert conn.status == 401
      assert conn.halted
    end
  end
  #
  # describe "GET show" do
  #   test "renders a blackout_option with a valid id", %{logged_in: conn} do
  #     settings = insert(:settings, user: conn.assigns.current_user)
  #     option = insert(:blackout_option, settings: settings)
  #     conn = get conn,
  #
  #   end
  # end
end
