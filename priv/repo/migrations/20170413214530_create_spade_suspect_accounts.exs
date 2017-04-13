defmodule Flatfoot.Repo.Migrations.CreateSpadeSuspectAssociations do
  use Ecto.Migration

  def change do
    create table(:spade_suspect_accounts) do
      add :suspect_id, references(:spade_suspects)
      add :backend_id, references(:archer_backends)
      add :handle, :string

      timestamps()
    end

    create index(:spade_suspect_accounts, [:suspect_id])
    create index(:spade_suspect_accounts, [:backend_id])
  end
end
