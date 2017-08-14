defmodule Flatfoot.Repo.Migrations.RenameArcherBackendsToBackends do
  use Ecto.Migration

  def change do
    rename table(:archer_backends), to: table(:backends)
  end
end
