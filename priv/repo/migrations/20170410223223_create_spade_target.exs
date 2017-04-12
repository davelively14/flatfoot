defmodule Flatfoot.Repo.Migrations.CreateSpadeWard do
  use Ecto.Migration

  def change do
    create table(:spade_wards) do
      add :user_id, references(:clients_users)
      add :name, :string
      add :relationship, :string
      add :active, :boolean

      timestamps()
    end

    create index(:spade_wards, [:user_id])
  end
end
