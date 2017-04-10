defmodule Flatfoot.Repo.Migrations.CreateArcherBackends do
  use Ecto.Migration

  def change do
    create table(:archer_backends) do
      add :name, :string
      add :name_snake, :string
      add :url, :string
      add :module, :string

      timestamps()
    end
  end
end
