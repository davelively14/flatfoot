defmodule Flatfoot.Repo.Migrations.BlackoutOptionsBelongToUser do
  use Ecto.Migration

  def change do
    drop index(:clients_blackout_options, [:settings_id])

    alter table(:clients_blackout_options) do
      remove :settings_id
      add :user_id, references(:clients_users)
    end

    create index(:clients_blackout_options, [:user_id])
  end
end
