defmodule Flatfoot.Shared.User do
  use Ecto.Schema

  schema "users" do
    has_many :sessions, Flatfoot.Clients.Session, on_delete: :delete_all
    has_many :notification_records, Flatfoot.Clients.NotificationRecord, on_delete: :delete_all
    has_many :blackout_options, Flatfoot.Clients.BlackoutOption, on_delete: :delete_all
    has_many :wards, Flatfoot.Spade.Ward, on_delete: :delete_all
    has_many :watchlists, Flatfoot.Spade.Watchlist, on_delete: :delete_all
  end
end
