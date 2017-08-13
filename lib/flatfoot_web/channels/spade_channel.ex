defmodule FlatfootWeb.SpadeChannel do
  use FlatfootWeb, :channel
  alias Flatfoot.{Spade, SpadeInspector}
  alias FlatfootWeb.{WardView, WardAccountView, Spade.WardResultView}

  @doc """
  On join, will return a fully preloaded user JSON response. Can only join a channel if you are the authorized user.

  Provide the channel name (i.e. "spade:0") and the socket. Params are unused.
  """
  def join("spade:" <> user_id, _params, socket) do
    cond do
      user_id |> String.to_integer != socket.assigns.user_id ->
        {:error, "Unauthorized"}
      user = Spade.get_user_preload(user_id) ->
        {:ok, Phoenix.View.render(FlatfootWeb.Spade.UserView, "user.json", %{user: user}), assign(socket, :user_id, user.id)}
      true ->
        {:error, "User does not exist"}
    end
  end

  @doc """
  On order, will fetch and return a fully preloaded user JSON response.

  Must include the "get_user" message, and a valid user_id within params object.

  Params requirement:
  "user_id": integer
  """
  def handle_in("get_user", _, socket) do
    if user = Spade.get_user_preload(socket.assigns.user_id) do
      broadcast! socket, "user_data", Phoenix.View.render(FlatfootWeb.Spade.UserView, "user.json", %{user: user})

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
  On order, retrieves recently stored results for a given ward_account_id

  Must include the "get_ward_account_results" message and a valid ward_account_id within params object.

  Params requirement:
  "ward_account_id": integer (required)
  "as_of": ISO date YYYY-MM-DD (optional)
  """
  def handle_in("get_ward_account_results", %{"ward_account_id" => id, "as_of" => as_of}, socket) do
    if Regex.match?(~r/\d{4}-\d{2}-\d{2}/, as_of) do
      results = Spade.list_ward_results(id, as_of)
      broadcast! socket, "ward_account_#{id}_results", Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: results})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end
  def handle_in("get_ward_account_results", %{"ward_account_id" => id}, socket) do
    results = Spade.list_ward_results(id)
    broadcast! socket, "ward_account_#{id}_results", Phoenix.View.render(FlatfootWeb.Spade.WardResultView, "ward_result_list.json", %{ward_results: results})

    {:reply, :ok, socket}
  end

  @doc """
  On order, retrieves the newest results for all active wards of a given user. Results are returned in order of newest to oldest.

  Must include the "get_ward_results_for_user" message and a valid user token within the params object.

  Params requirement:
  "token": string (required)
  "as_of": ISO date YYYY-MM-DD (optional)
  """
  def handle_in("get_ward_results_for_user", %{"token" => token, "as_of" => as_of}, socket) do
    if Regex.match?(~r/\d{4}-\d{2}-\d{2}/, as_of) do
      results = Spade.list_ward_results_by_user(token, as_of)
      broadcast! socket, "user_ward_results", Phoenix.View.render(WardResultView, "ward_result_list.json", %{ward_results: results})

      {:reply, :ok, socket}
    else
      {:reply, :error, socket}
    end
  end
  def handle_in("get_ward_results_for_user", %{"token" => token}, socket) do
    results = Spade.list_ward_results_by_user(token)
    broadcast! socket, "user_ward_results", Phoenix.View.render(WardResultView, "ward_result_list.json", %{ward_results: results})

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
    SpadeInspector.fetch_update(id)

    {:reply, :ok, socket}
  end

  @doc """
  Will receive a new_ward_results broadcast from the SpadeInspector.Sever module.
  """
  def handle_in("new_ward_results", %{"ward_results" => _results}, socket) do

    {:noreply, :ok, socket}
  end

  @doc """
  On order, returns a list of all the backends like this:
  %{backends: [backend, backend...]}

  Must include "fetch_backends".
  """
  def handle_in("fetch_backends", %{}, socket) do
    backends =
      Spade.list_backends()
      |> Enum.map(&Map.take(&1, [:name, :url, :module, :id]))

    broadcast! socket, "backends_list", %{backends: backends}

    {:reply, :ok, socket}
  end

  @doc """
  With valid parameters, will create a new ward and return the new ward.

  Must include "create_ward" message and valid "ward_params".

  Params requirement:
  "ward_params": map (required)
   -> valid parameters for "ward_params":
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
  "updated_params": map (required)
   -> valid parameters for "updated_params":
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
          ward_account = ward_account |> Flatfoot.Repo.preload(:backend)
          broadcast! socket, "new_ward_account", Phoenix.View.render(WardAccountView, "ward_account_preloaded_backend.json", %{ward_account: ward_account})
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

  @doc """
  With a valid ward_account id, will delete that ward_account and return it via broadcast!

  Must include "delete_ward_account" and a valid id as a prameter.

  Params requirement:
  "id": integer (required)
  """
  def handle_in("delete_ward_account", %{"id" => id}, socket) do
    if ward_account = Spade.get_ward_account(id) do
      owner_id = ward_account.ward_id |> Spade.get_ward() |> Map.get(:user_id)

      if socket.assigns.user_id == owner_id do
        {:ok, deleted_account} = Spade.delete_ward_account(id)
        deleted_account = deleted_account |> Flatfoot.Repo.preload(:backend)
        broadcast! socket, "deleted_ward_account", Phoenix.View.render(WardAccountView, "ward_account_preloaded_backend.json", %{ward_account: deleted_account})
      else
        broadcast! socket, "Error: Unauthorized to delete another user's ward_account", %{}
      end
    else
      broadcast! socket, "Error: invalid id", %{"id" => id}
    end

    {:reply, :ok, socket}
  end

  @doc """
  With a valid ward_account id and params, will update and return the existing ward.

  Must include "update_ward_account", a valid id, and valid new parameters.

  Params requirement:
  "id": integer (required)
  "updated_params": map (required)
  -> valid parameters for "updated_params":
    - "handle": string (optional)
    - "backend_id": id (optional)
  """
  def handle_in("update_ward_account", %{"id" => id, "updated_params" => updated_params}, socket) do
    if ward_account = Spade.get_ward_account(id) do
      owner_id = ward_account.ward_id |> Spade.get_ward() |> Map.get(:user_id)

      if socket.assigns.user_id == owner_id do
        updated_params = Map.take(updated_params, ["handle", "backend_id"])

        {:ok, updated_ward_account} = Spade.update_ward_account(id, updated_params)
        updated_ward_account = updated_ward_account |> Flatfoot.Repo.preload(:backend)

        broadcast! socket, "updated_ward_account", Phoenix.View.render(WardAccountView, "ward_account_preloaded_backend.json", %{ward_account: updated_ward_account})
      else
        broadcast! socket, "Error: unauthorized to edit ward_account", %{}
      end
    else
      broadcast! socket, "Error: invalid id", %{"id" => id}
    end

    {:reply, :ok, socket}
  end

  @doc """
  With a valid ward_result_id, will clear that particular result.

  Must include "clear_ward_result" and a valid id.

  Params requirement:
  "id": integer (required)
  """
  def handle_in("clear_ward_result", %{"id" => id}, socket) do
    if ward_result = Spade.get_ward_result(id) do
      owner_id = ward_result.ward_account_id |> Spade.get_ward_account() |> Map.get(:ward_id) |> Spade.get_ward() |> Map.get(:user_id)

      if socket.assigns.user_id == owner_id do
        {:ok, deleted_result} = Spade.delete_ward_result(id)
        broadcast! socket, "cleared_ward_result", Phoenix.View.render(WardResultView, "ward_result.json", %{ward_result: deleted_result})
      else
        broadcast! socket, "Error: unauthorized to clear ward_result", %{}
      end
    else
      broadcast! socket, "Error: invalid ward_result id", %{"id" => id}
    end

    {:reply, :ok, socket}
  end

  @doc """
  With a valid ward_account_id, clears all results for a particular ward_account.

  Must include "clear_ward_results" and a valid ward_account_id.

  Params requirement:
  "ward_account_id": integer (required)
  """
  def handle_in("clear_ward_results", %{"ward_account_id" => id}, socket) do
    if Spade.get_ward_account(id) do
      ward_account = Spade.get_ward_account_preload!(id)
      owner_id = ward_account.ward_id |> Spade.get_ward() |> Map.get(:user_id)

      if socket.assigns.user_id == owner_id do
        deleted_results = ward_account.ward_results |> delete_results
        broadcast! socket, "cleared_ward_results", Phoenix.View.render(WardResultView, "ward_result_list.json", %{ward_results: deleted_results})
      else
        broadcast! socket, "Error: unauthorized to access this ward_account", %{}
      end
    else
      broadcast! socket, "Error: invalid ward_account id", %{"ward_account_id" => id}
    end

    {:reply, :ok, socket}
  end

  @doc """
  With a valid ward_id, clears all results for a particular ward.

  Must include "clear_ward_results" and a valid ward_id.

  Params requirement:
  "ward_id": integer (required)
  """
  def handle_in("clear_ward_results", %{"ward_id" => id}, socket) do
    if ward = Spade.get_ward_preload_with_results(id) do
      if socket.assigns.user_id == ward.user_id do
        deleted_results = ward.ward_accounts |> delete_nested_results
        broadcast! socket, "cleared_ward_results", Phoenix.View.render(WardResultView, "ward_result_list.json", %{ward_results: deleted_results})
      else
        broadcast! socket, "Error: unauthorized to access this ward", %{}
      end
    else
      broadcast! socket, "Error: invalid ward id", %{"ward_id" => id}
    end

    {:reply, :ok, socket}
  end

  #####################
  # Private Functions #
  #####################

  defp delete_results(results), do: delete_results(results, [])
  defp delete_results([], list_of_deleted), do: list_of_deleted
  defp delete_results([head | tail], list_of_deleted) do
    {:ok, deleted_head} = Spade.delete_ward_result(head.id)
    delete_results(tail, [deleted_head | list_of_deleted])
  end

  defp delete_nested_results(accounts), do: delete_nested_results(accounts, [])
  defp delete_nested_results([], list_of_deleted), do: list_of_deleted
  defp delete_nested_results([head | tail], list_of_deleted) do
    deleted_results = delete_results(head.ward_results)
    delete_nested_results(tail, [deleted_results | list_of_deleted] |> List.flatten)
  end
end
