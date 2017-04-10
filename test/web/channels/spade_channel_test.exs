defmodule Flatfoot.Web.SpadeChannelTest do
  use Flatfoot.Web.ChannelCase
  alias Flatfoot.Web.{SpadeChannel}

  describe "join" do
    test "will return response and socket" do
      user = insert(:user)
      {:ok, message, socket} = socket("", %{}) |> subscribe_and_join(SpadeChannel, "spade:#{user.id}")

      assert message == "#{user.username} joined"
      assert socket.assigns.user_id == user.id |> to_string
      assert socket.channel == Flatfoot.Web.SpadeChannel
    end
  end
end
