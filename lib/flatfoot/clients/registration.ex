defmodule Flatfoot.Clients.Registration do
  use Ecto.Schema

  embedded_schema do
    field :username
    field :email
    field :password
  end
end
