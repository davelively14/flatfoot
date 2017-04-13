defmodule Flatfoot.Repo.Migrations.CreateSpadeSuspects do
  use Ecto.Migration

  def change do
    create table(:spade_suspects) do
      add :user_id, references(:clients_users)
      add :name, :string
      add :category, :string
      add :notes, :text
      add :active, :boolean

      timestamps()
    end

    create index(:spade_suspects, [:user_id])
  end
end
