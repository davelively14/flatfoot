defmodule Flatfoot.Repo.Migrations.CreateSpadeTarget do
  use Ecto.Migration

  def change do
    create table(:spade_targets) do
      add :user_id, references(:clients_users)
      add :name, :string
      add :relationship, :string
      add :active, :boolean

      timestamps()
    end

    create index(:spade_targets, [:user_id])
  end
end
