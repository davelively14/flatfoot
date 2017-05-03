defmodule Flatfoot.Web.SpadeChannel do
  use Flatfoot.Web, :channel
  alias Flatfoot.{Spade}

  def join("spade:" <> user_id, _params, socket) do
    if user = Spade.get_user_preload(user_id) do
      {:ok, Phoenix.View.render(Flatfoot.Web.Spade.UserView, "user.json", %{user: user}), assign(socket, :user_id, user.id)}
    else
      {:error, "User does not exist"}
    end
  end

  def handle_in("get_user", params, socket) do
    if user = Spade.get_user_preload(params["user_id"]) do
      broadcast! socket, "user_data", Phoenix.View.render(Flatfoot.Web.Spade.UserView, "user.json", %{user: user})
      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end

  # def handle_in("get_ward", params, socket) do
  #   if ward = Spade.get_ward_preload!(params["ward_id"]) do
  #     {:reply, Phoenix.View.render(Flatfoot.Web.Spade.WardView, "ward.json", %{ward: ward}), socket}
  #   else
  #     {:reply, :error, socket}
  #   end
  # end
end
