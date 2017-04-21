defmodule Flatfoot.Archer.Backend.Twitter do
  def fetch(channel_pid, query) do
    send(channel_pid, query)
  end
end
