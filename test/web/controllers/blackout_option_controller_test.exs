defmodule Flatfoot.Web.BlackoutOptionControllerTest do
  use Flatfoot.Web.ConnCase

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
      insert(:blackout_option, settings: settings)
      conn = get conn, blackout_option_path(conn, :index), %{settings_id: settings.id}
      assert %{"errors" => "Unauthorized. Can not view or edit content for another user."} == json_response(conn, 401)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      settings = insert(:settings)
      insert_list(3, :blackout_option, settings: settings)

      conn = get conn, blackout_option_path(conn, :index), %{settings_id: settings.id}
      assert conn.status == 401
      assert conn.halted
    end

    test "with no settings_id returns ActionClauseError", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      insert_list(3, :blackout_option, settings: settings)
      insert_list(2, :blackout_option)

      assert_raise Phoenix.ActionClauseError, fn -> get conn, blackout_option_path(conn, :index) end
    end
  end

  describe "GET show" do
    test "renders a blackout_option with a valid id", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      option = insert(:blackout_option, settings: settings)

      conn = get conn, blackout_option_path(conn, :show, option.id)
      assert %{"data" => result} = json_response(conn, 200)

      assert result["id"] == option.id
      assert result["start"] == option.start |> Ecto.Time.to_string
      assert result["stop"] == option.stop |> Ecto.Time.to_string
      assert result["threshold"] == option.threshold
      assert result["exclude"] == option.exclude
      assert result["settings_id"] == option.settings_id
    end

    test "raises error on invalid id", %{logged_in: conn} do
      assert_raise Ecto.NoResultsError, fn -> get conn, blackout_option_path(conn, :show, 12) end
    end

    test "will return 401 and error when trying to view another user's blackout option", %{logged_in: conn} do
      settings = insert(:settings)
      option = insert(:blackout_option, settings: settings)

      conn = get conn, blackout_option_path(conn, :show, option.id)
      assert %{"errors" => "Unauthorized. Can not view or edit content for another user."} == json_response(conn, 401)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      option = insert(:blackout_option)

      conn = get conn, blackout_option_path(conn, :show, option.id)
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "POST create" do
    setup :generic_params

    test "with valid attributes will create a blackout option", %{logged_in: conn, valid_params: valid_params} do
      conn = post conn, blackout_option_path(conn, :create), params: valid_params
      assert %{"data" => option} = json_response(conn, 201)

      assert option["settings_id"] == valid_params.settings_id
      assert option["threshold"] == valid_params.threshold
      assert option["start"] == valid_params.start |> Ecto.Time.to_string
      assert option["stop"] == valid_params.stop |> Ecto.Time.to_string
      assert option["exclude"] == valid_params.exclude
    end

    test "with invalid time formats for start and stop will return errors", %{logged_in: conn, bad_time_params: bad_time_params} do
      conn = post conn, blackout_option_path(conn, :create), params: bad_time_params
      assert %{"errors" => errors} = json_response(conn, 422)
      assert errors["start"] == ["is invalid"]
      assert errors["stop"] == ["is invalid"]
    end

    test "with invalid attributes will return errors", %{logged_in: conn, invalid_params: invalid_params} do
      conn = post conn, blackout_option_path(conn, :create), params: invalid_params
      assert %{"errors" => errors} = json_response(conn, 422)

      assert errors["threshold"] == ["is invalid"]
      assert errors["exclude"] == ["is invalid"]
      assert errors["stop"] == ["can't be blank"]
      assert errors["start"] == ["can't be blank"]
      assert errors["settings_id"] == ["can't be blank"]
    end

    test "cannot create a blackout option for another user's settings", %{logged_in: conn, valid_params: valid_params} do
      new_settings = insert(:settings)
      new_params = valid_params |> Map.update!(:settings_id, &(&1 = new_settings.id))

      conn = post conn, blackout_option_path(conn, :create), params: new_params
      assert %{"errors" => "Unauthorized. Can not view or edit content for another user."} == json_response(conn, 401)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn, valid_params: valid_params} do
      conn = post conn, blackout_option_path(conn, :create), params: valid_params
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "PUT update" do
    test "with valid attrs will update a blackout option", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      blackout_option = insert(:blackout_option, settings: settings)

      conn = put conn, blackout_option_path(conn, :update, blackout_option), params: %{exclude: "new string"}
      assert %{"data" => result} = json_response(conn, 200)

      assert result["threshold"] == blackout_option.threshold
      assert result["settings_id"] == blackout_option.settings_id
      assert result["exclude"] != blackout_option.exclude
      assert result["exclude"] == "new string"
    end

    test "raises Ecto.ConstraintError on attempt to change settings_id", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      blackout_option = insert(:blackout_option, settings: settings)

      assert_raise Ecto.ConstraintError, fn -> put conn, blackout_option_path(conn, :update, blackout_option), params: %{settings_id: 1} end
    end

    test "raises error with a bad id", %{logged_in: conn} do
      assert_raise Ecto.NoResultsError, fn -> put conn, blackout_option_path(conn, :update, 0), params: %{threshold: 50} end
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      blackout_option = insert(:blackout_option)
      conn = put conn, blackout_option_path(conn, :update, blackout_option), params: %{threshold: 50}
      assert conn.status == 401
      assert conn.halted
    end
  end

  describe "DELETE delete" do
    test "with valid id can delete own blackout option", %{logged_in: conn} do
      settings = insert(:settings, user: conn.assigns.current_user)
      blackout_option = insert(:blackout_option, settings: settings)

      conn = delete conn, blackout_option_path(conn, :delete, blackout_option)
      assert "" == response(conn, 204)
    end

    test "cannot delete another user's blackout option", %{logged_in: conn} do
      blackout_option = insert(:blackout_option)

      conn = delete conn, blackout_option_path(conn, :delete, blackout_option)
      assert %{"errors" => "Unauthorized. Can not view or edit content for another user."} == json_response(conn, 401)
    end

    test "with invalid token returns 401 and halts", %{not_logged_in: conn} do
      blackout_option = insert(:blackout_option)
      conn = delete conn, blackout_option_path(conn, :delete, blackout_option)
      assert conn.status == 401
      assert conn.halted
    end
  end

  ##########
  # Setups #
  ##########i

  defp generic_params(context) do
    settings_id = insert(:settings, user: context.logged_in.assigns.current_user) |> Map.get(:id)

    valid_params = %{
      start: Ecto.Time.cast({Enum.random(0..23), Enum.random([0,30]), 0}) |> elem(1),
      stop: Ecto.Time.cast({Enum.random(0..23), Enum.random([0,30]), 0}) |> elem(1),
      threshold: Enum.random(0..100),
      exclude: "[#{Faker.Address.state_abbr}, #{Faker.Address.state_abbr}]",
      settings_id: settings_id
    }

    bad_time_params = %{
      start: "3:45pm",
      stop: "noonish",
      threshold: Enum.random(0..100),
      exclude: "[#{Faker.Address.state_abbr}, #{Faker.Address.state_abbr}]",
      settings_id: settings_id
    }

    invalid_params = %{
      start: nil,
      stop: nil,
      threshold: "hello",
      exclude: 123,
      settings_id: nil
    }

    {:ok, %{valid_params: valid_params, bad_time_params: bad_time_params, invalid_params: invalid_params}}
  end
end
