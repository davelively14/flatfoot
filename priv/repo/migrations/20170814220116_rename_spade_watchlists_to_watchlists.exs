defmodule Flatfoot.Repo.Migrations.RenameSpadeWatchlistsToWatchlists do
  use Ecto.Migration

  def change do
    rename table(:spade_watchlists), to: table(:watchlists)
  end
end
