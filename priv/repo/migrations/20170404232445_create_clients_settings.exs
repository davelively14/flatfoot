defmodule Flatfoot.Repo.Migrations.CreateClientsSettings do
  use Ecto.Migration

  def change do
    create table(:clients_settings) do
      add :user_id, references(:clients_users)
      add :global_threshold, :integer

      timestamps()
    end

    create index(:clients_settings, [:user_id])
  end
end
