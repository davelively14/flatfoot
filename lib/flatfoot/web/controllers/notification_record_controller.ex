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
end
