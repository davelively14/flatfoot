defmodule Flatfoot.Repo.Migrations.CreateSpadeWatchlist do
  use Ecto.Migration

  def change do
    create table(:spade_watchlists) do
      add :user_id, references(:clients_users)
      add :name, :string

      timestamps()
    end

    create index(:spade_watchlists, [:user_id])
  end
end
