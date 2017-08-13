defmodule FlatfootWeb.NotificationRecordController do
  use FlatfootWeb, :controller

  alias Flatfoot.{Clients, Clients.NotificationRecord}

  action_fallback FlatfootWeb.FallbackController

  def create(conn, %{"params" => params}) do
    params = params |> add_current_user_id(conn)

    with {:ok, %NotificationRecord{} = record} <- Clients.create_notification_record(params) do
      conn
      |> put_status(:created)
      |> render("show.json", notification_record: record)
    end
  end

  def index(conn, _) do
    notification_records = Clients.list_notification_records(conn.assigns.current_user.id)
    render(conn, "index.json", notification_records: notification_records)
  end

  def show(conn, %{"id" => id}) do
    record = Clients.get_notification_record!(id, conn.assigns.current_user.id)
    render(conn, "show.json", notification_record: record)
  end

  def update(conn, %{"id" => id, "params" => params}) do
    record = Clients.get_notification_record!(id, conn.assigns.current_user.id)
    params = params |> clear_user_id

    if record do
      {:ok, result} = Clients.update_notification_record(record, params)
      render(conn, "show.json", notification_record: result)
    else
      render(conn, "error.json", error: "That record does not exist or is not available for this user")
    end
  end

  def delete(conn, %{"id" => id}) do
    record = Clients.get_notification_record!(id, conn.assigns.current_user.id)
    if record do
      with {:ok, %NotificationRecord{}} <- Clients.delete_notification_record(record) do
        send_resp(conn, :no_content, "")
      end
    else
      render(conn, "error.json", error: "That record does not exist or is not available for this user")
    end
  end

  #####################
  # Private Functions #
  #####################

  defp clear_user_id(params), do: params |> Map.delete("user_id")
  defp add_current_user_id(params, conn), do: params |> Map.merge(%{"user_id" => conn.assigns.current_user.id})
end
