defmodule Flatfoot.Archer.Backend.Twitter do
  def fetch(channel_pid) do
    send(channel_pid, "hello world")
  end
end
