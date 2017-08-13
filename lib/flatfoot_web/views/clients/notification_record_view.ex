defmodule FlatfootWeb.NotificationRecordView do
  use FlatfootWeb, :view
  alias FlatfootWeb.NotificationRecordView

  def render("show.json", %{notification_record: notification_record}) do
    %{data: render_one(notification_record, NotificationRecordView, "notification_record.json")}
  end

  def render("index.json", %{notification_records: notification_records}) do
    %{data: render_many(notification_records, NotificationRecordView, "notification_record.json")}
  end

  def render("error.json", %{error: error}) do
    %{errors: error}
  end

  def render("notification_record.json", %{notification_record: record}) do
    %{
      id: record.id,
      user_id: record.user_id,
      nickname: record.nickname,
      email: record.email,
      role: record.role,
      threshold: record.threshold
    }
  end
end
