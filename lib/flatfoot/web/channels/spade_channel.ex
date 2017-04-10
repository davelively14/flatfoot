defmodule Flatfoot.Web.SpadeChannel do
  use Flatfoot.Web, :channel
  alias Flatfoot.{Clients}

  def join("spade:" <> user_id, _params, socket) do
    user = Clients.get_user!(user_id)
    {:ok, "#{user.username} joined", assign(socket, :user_id, user_id)}
  end
end
