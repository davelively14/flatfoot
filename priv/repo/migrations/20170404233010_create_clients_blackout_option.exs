defmodule Flatfoot.Repo.Migrations.CreateClientsBlackoutOption do
  use Ecto.Migration

  def change do
    create table(:clients_blackout_options) do
      add :settings_id, references(:clients_settings)
      add :start, :time
      add :end, :time
      add :threshold, :integer
      add :exclude, :string

      timestamps()
    end

    create index(:clients_blackout_options, [:settings_id])
  end
end
