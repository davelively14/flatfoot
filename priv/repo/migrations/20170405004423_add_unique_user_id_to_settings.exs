defmodule Flatfoot.Repo.Migrations.AddUniqueUserIdToSettings do
  use Ecto.Migration

  def change do
    drop_if_exists index(:clients_settings, [:user_id])
    create_if_not_exists unique_index(:clients_settings, [:user_id])
  end
end
