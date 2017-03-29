defmodule Flatfoot.Repo.Migrations.CreateFlatfoot.Clients.User do
  use Ecto.Migration

  def change do
    create table(:clients_users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:clients_users, [:username])
    create unique_index(:clients_users, [:email])
  end
end
