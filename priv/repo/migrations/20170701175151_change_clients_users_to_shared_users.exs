defmodule Flatfoot.Repo.Migrations.ChangeClientsUsersToSharedUsers do
  use Ecto.Migration

  def change do
    rename table(:clients_users), to: table(:shared_users)
    rename table(:clients_users_id_seq), to: table(:shared_users_id_seq)
  end
end
