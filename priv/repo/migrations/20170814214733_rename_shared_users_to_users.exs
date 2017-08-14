defmodule Flatfoot.Repo.Migrations.RenameSharedUsersToUsers do
  use Ecto.Migration

  def change do
    rename table(:shared_users), to: table(:users)
  end
end
