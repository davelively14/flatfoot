defmodule Flatfoot.Repo.Migrations.DropClientsSettingsTable do
  use Ecto.Migration

  def change do
    drop table(:clients_settings)
  end
end
