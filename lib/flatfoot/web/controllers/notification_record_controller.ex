defmodule Flatfoot.Web.NotificationRecordController do
  use Flatfoot.Web, :controller

  alias Flatfoot.{Clients, Clients.NotificationRecord}

  action_fallback Flatfoot.Web.FallbackController

  def create(conn, %{"params" => params}) do
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
end
