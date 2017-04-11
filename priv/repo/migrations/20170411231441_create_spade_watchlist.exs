defmodule Flatfoot.Repo.Migrations.CreateSpadeWatchlist do
  use Ecto.Migration

  def change do
    create table(:spade_watchlist) do
      add :user_id, references(:clients_users)
      add :name, :string

      timestamps()
    end

    create index(:spade_watchlist, [:user_id])
  end
end
