defmodule Flatfoot.Repo.Migrations.RenameSpadeSuspectAccountsToSuspectAccounts do
  use Ecto.Migration

  def change do
    rename table(:spade_suspect_accounts), to: table(:suspect_accounts)
  end
end
