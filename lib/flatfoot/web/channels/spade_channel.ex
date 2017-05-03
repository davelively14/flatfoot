defmodule Flatfoot.Web.SpadeChannel do
  use Flatfoot.Web, :channel
  alias Flatfoot.{Spade}

  @doc """
  On join, will return a fully preloaded user JSON response.

  Provide the channel name (i.e. "spade:0") and the socket. Params are unused.
  """
  def join("spade:" <> user_id, _params, socket) do
    if user = Spade.get_user_preload(user_id) do
      {:ok, Phoenix.View.render(Flatfoot.Web.Spade.UserView, "user.json", %{user: user}), assign(socket, :user_id, user.id)}
    else
      {:error, "User does not exist"}
    end
  end

  @doc """
  On order, will fetch and return a fully preloaded user JSON response.

  Must include the "get_user" message, a valid user_id within params object, and the socket.

  Params requirement:
  "user_id": integer
  """
  def handle_in("get_user", params, socket) do
    if user = Spade.get_user_preload(params["user_id"]) do
      broadcast! socket, "user_data", Phoenix.View.render(Flatfoot.Web.Spade.UserView, "user.json", %{user: user})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end

  @doc """
  On order, will fetch and return a fully preloaded ward JSON response.

  Must include the "get_ward" message, a valid ward_id within params object, and the socket.

  Params requirement:
  "ward_id": integer
  """
  def handle_in("get_ward", params, socket) do
    if ward = Spade.get_ward_preload(params["ward_id"]) do
      broadcast! socket, "ward_#{ward.id}_data", Phoenix.View.render(Flatfoot.Web.WardView, "ward.json", %{ward: ward})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end
end
