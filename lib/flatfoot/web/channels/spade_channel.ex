defmodule Flatfoot.Web.SpadeChannel do
  use Flatfoot.Web, :channel
  alias Flatfoot.{Spade, SpadeInspector, Web.WardView, Web.WardAccountView}

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

  Must include the "get_user" message, and a valid user_id within params object.

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

  Must include the "get_ward" message, and a valid ward_id within params object.

  Params requirement:
  "ward_id": integer
  """
  def handle_in("get_ward", params, socket) do
    if ward = Spade.get_ward_preload(params["ward_id"]) do
      broadcast! socket, "ward_#{ward.id}_data", Phoenix.View.render(WardView, "ward_preload.json", %{ward: ward})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end

  @doc """
  On order, fetches recently stored results for a given ward_account_id

  Must include the "get_ward_account_results" message and a valid ward_account_id within params object.

  Params requirement:
  "ward_account_id": integer (required)
  "as_of": ISO date YYYY-MM-DD (optional)
  """
  def handle_in("get_ward_account_results", %{"ward_account_id" => id, "as_of" => as_of}, socket) do
    if Regex.match?(~r/\d{4}-\d{2}-\d{2}/, as_of) do
      results = Spade.list_ward_results(id, as_of)
      broadcast! socket, "ward_account_#{id}_results", Phoenix.View.render(Flatfoot.Web.Spade.WardResultView, "ward_result_list.json", %{ward_results: results})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end
  def handle_in("get_ward_account_results", %{"ward_account_id" => id}, socket) do
    results = Spade.list_ward_results(id)
    broadcast! socket, "ward_account_#{id}_results", Phoenix.View.render(Flatfoot.Web.Spade.WardResultView, "ward_result_list.json", %{ward_results: results})

    {:reply, :ok, socket}
  end

  @doc """
  On order, fetches the newest results for all active wards of a given user. Results are returned in order of newest to oldest.

  Must include the "get_ward_results_for_user" message and a valid user token within the params object.

  Params requirement:
  "token": string (required)
  "as_of": ISO date YYYY-MM-DD (optional)
  """
  def handle_in("get_ward_results_for_user", %{"token" => token, "as_of" => as_of}, socket) do
    if Regex.match?(~r/\d{4}-\d{2}-\d{2}/, as_of) do
      results = Spade.list_ward_results_by_user(token, as_of)
      broadcast! socket, "user_ward_results", Phoenix.View.render(Flatfoot.Web.Spade.WardResultView, "ward_result_list.json", %{ward_results: results})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end
  def handle_in("get_ward_results_for_user", %{"token" => token}, socket) do
    results = Spade.list_ward_results_by_user(token)
    broadcast! socket, "user_ward_results", Phoenix.View.render(Flatfoot.Web.Spade.WardResultView, "ward_result_list.json", %{ward_results: results})

    {:reply, :ok, socket}
  end

  @doc """
  On order, fetches new results for a given ward. Will automaticaly load results
  for all associated ward_accounts.

  Must include the "fetch_new_ward_results" message and a valid ward_id.

  Params requirement:
  "ward_id": integer (required)
  """
  def handle_in("fetch_new_ward_results", %{"ward_id" => id}, socket) do
    SpadeInspector.Server.fetch_update(id)

    {:reply, :ok, socket}
  end

  @doc """
  Will receive a new_ward_results broadcast from the SpadeInspector.Sever module.
  """
  def handle_in("new_ward_results", %{"results" => _results}, socket) do

    {:noreply, :ok, socket}
  end

  @doc """
  On order, returns a list of all the backends like this:
  %{backends: [backend, backend...]}

  Must include "fetch_backends".
  """
  def handle_in("fetch_backends", %{}, socket) do
    backends = Spade.list_backends()
    broadcast! socket, "backends_list", %{backends: backends}

    {:reply, :ok, socket}
  end

  @doc """
  With valid parameters, will create a new ward and return the new ward.

  Must include "create_ward" message and valid "ward_params".

  Params requirement:
  "ward_params": map (required)
   -> valid parameters for "ward_params":
    - "user_id": integer (required)
    - "name": string (required)
    - "relationship": string (required)
    - "active": boolean (optional)
  """
  def handle_in("create_ward", %{"ward_params" => attrs}, socket) do
    if attrs["name"] && attrs["relationship"] do
      submit_params = %{user_id: socket.assigns.user_id, name: attrs["name"], relationship: attrs["relationship"], active: attrs["active"]}
      {:ok, new_ward} = Spade.create_ward(submit_params)
      broadcast! socket, "new_ward", Phoenix.View.render(WardView, "ward.json", %{ward: new_ward})
    else
      broadcast! socket, "Error: invalid attributes passed for create_ward", attrs
    end

    {:reply, :ok, socket}
  end

  @doc """
  With a valid id, will delete a ward and return the ward that was just deleted.

  Must include "delete_ward" message and a valid id.

  Params requirement:
  "id": integer (required)
  """
  def handle_in("delete_ward", %{"id" => id}, socket) when is_integer(id) do
    if ward = Spade.get_ward(id) do
      cond do
        socket.assigns.user_id == ward.user_id ->
          {:ok, deleted_ward} = Spade.delete_ward(id)
          broadcast! socket, "deleted_ward", Phoenix.View.render(WardView, "ward.json", %{ward: deleted_ward})
        true ->
          broadcast! socket, "Error: unauthorized to delete ward", %{}
      end
    else
      broadcast! socket, "Error: invalid ward id for delete_ward", %{"id" => id}
    end

    {:reply, :ok, socket}
  end

  @doc """
  With a valid id and params, will update a ward and return the updated ward.

  Must include "update_ward", a valid id, and valid new parameters.

  Params requirement:
  "id": integer (required)
  "ward_params": map (required)
   -> valid parameters for "ward_params":
    - "name": string (optional)
    - "relationship": string (optional)
    - "active": boolean (optional)
  """
  def handle_in("update_ward", %{"id" => id, "updated_params" => updated_params}, socket) do
    if ward = Spade.get_ward(id) do
      cond do
        socket.assigns.user_id == ward.user_id ->
          updated_params = Map.take(updated_params, ["name", "relationship", "active"])

          {:ok, updated_ward} = Spade.update_ward(id, updated_params)
          broadcast! socket, "updated_ward", Phoenix.View.render(WardView, "ward.json", %{ward: updated_ward})

        true ->
          broadcast! socket, "Error: unauthorized to edit ward", %{}
      end
    else
      broadcast! socket, "Error: invalid ward_id", %{"id" => id}
    end

    {:reply, :ok, socket}
  end

  @doc """
  With valid parameters, create a new ward_account and return the newly created ward_account.

  Must include "create_ward_account" and valid parameters.

  Params requirement:
  "ward_account_params": map (required)
  -> valid parameters for "ward_account_params":
    - "handle": string (required)
    - "ward_id": integer (required)
    - "backend_id": integer (required)
  """
  def handle_in("create_ward_account", %{"ward_account_params" => params}, socket) do
    if params["handle"] && params["ward_id"] && params["backend_id"] do
      ward = Spade.get_ward(params["ward_id"])
      backend = Spade.get_backend(params["backend_id"])
      if ward && backend do
        if ward.user_id == socket.assigns.user_id do
          {:ok, ward_account} = Spade.create_ward_account(params)
          broadcast! socket, "new_ward_account", Phoenix.View.render(WardAccountView, "ward_account.json", %{ward_account: ward_account})
        else
          broadcast! socket, "Error: unauthorized to add a ward_account for another user's ward", %{}
        end
      else
        broadcast! socket, "Error: invalid ward or backend association", %{ward_id: params["ward_id"], backend_id: params["backend_id"]}
      end
    else
      broadcast! socket, "Error: invalid parameters", %{"ward_account_params" => params}
    end

    {:reply, :ok, socket}
  end
end
