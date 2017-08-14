defmodule Flatfoot.Repo.Migrations.RenameClientsNotificationRecordsToNotificationRecords do
  use Ecto.Migration

  def change do
    rename table(:clients_notification_records), to: table(:notification_records)
  end
end
