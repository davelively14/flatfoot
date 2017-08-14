defmodule Flatfoot.Repo.Migrations.RenameSpadeWardAccountsToWardAccounts do
  use Ecto.Migration

  def change do
    rename table(:spade_ward_accounts), to: table(:ward_accounts)
  end
end
