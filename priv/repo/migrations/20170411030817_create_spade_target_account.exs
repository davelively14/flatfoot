defmodule Flatfoot.Repo.Migrations.CreateSpadeWardAccount do
  use Ecto.Migration

  def change do
    create table(:spade_ward_accounts) do
      add :ward_id, references(:spade_wards)
      add :backend_id, references(:archer_backends)
      add :handle, :string

      timestamps()
    end

    create index(:spade_ward_accounts, [:ward_id])
    create index(:spade_ward_accounts, [:backend_id])
  end
end
