defmodule Flatfoot.Repo.Migrations.CreateClientsNotificationRecords do
  use Ecto.Migration

  def change do
    create table(:clients_notification_records) do
      add :user_id, references(:clients_users)
      add :nickname, :string
      add :email, :string
      add :role, :string
      add :threshold, :integer

      timestamps()
    end

    create index(:clients_notification_records, [:user_id])
  end
end
