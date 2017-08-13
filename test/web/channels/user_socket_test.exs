defmodule FlatfootWeb.UserSocketTest do
  use FlatfootWeb.ChannelCase
  use Phoenix.ConnTest, only: [:get]
  alias FlatfootWeb.UserSocket

  describe "JOIN" do
    setup :login_user_setup

    test "user with valid token can create a UserSocket", %{logged_in: conn} do
      conn = get conn, session_path(conn, :get_ws_token)
      %{"token" => token} = json_response(conn, 200)

      {:ok, _socket} = Phoenix.ChannelTest.connect(UserSocket, %{token: token})
    end

    test "user with invalid token receives :error" do
      :error = Phoenix.ChannelTest.connect(UserSocket, %{token: "hello"})
    end
  end
end
