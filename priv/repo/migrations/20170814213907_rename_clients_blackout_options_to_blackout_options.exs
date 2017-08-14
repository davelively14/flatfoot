defmodule Flatfoot.Repo.Migrations.RenameClientsBlackoutOptionsToBlackoutOptions do
  use Ecto.Migration

  def change do
    rename table(:clients_blackout_options), to: table(:blackout_options)
  end
end
