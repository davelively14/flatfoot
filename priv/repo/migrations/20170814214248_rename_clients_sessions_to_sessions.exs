defmodule Flatfoot.Repo.Migrations.RenameClientsSessionsToSessions do
  use Ecto.Migration

  def change do
    rename table(:clients_sessions), to: table(:sessions)
  end
end
