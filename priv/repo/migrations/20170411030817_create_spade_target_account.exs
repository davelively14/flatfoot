defmodule Flatfoot.Repo.Migrations.CreateSpadeTargetAccount do
  use Ecto.Migration

  def change do
    create table(:spade_target_accounts) do
      add :target_id, references(:spade_targets)
      add :backend_id, references(:archer_backends)
      add :handle, :string

      timestamps()
    end

    create index(:spade_target_accounts, [:target_id])
    create index(:spade_target_accounts, [:backend_id])
  end
end
