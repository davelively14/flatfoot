defmodule Flatfoot.Repo.Migrations.CreateSpadeWardResults do
  use Ecto.Migration

  def change do
    create table(:spade_ward_results) do
      add :ward_id, references(:spade_wards)
      add :backend_id, references(:archer_backends)
      add :rating, :integer
      add :from, :string
      add :msg_id, :string
      add :msg_text, :text

      timestamps()
    end

    create index(:spade_ward_results, [:ward_id])
    create index(:spade_ward_results, [:backend_id])
  end
end
