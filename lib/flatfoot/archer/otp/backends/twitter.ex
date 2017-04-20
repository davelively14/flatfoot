defmodule Flatfoot.Archer.Backend.Twitter do


  def start_link(opts) do
    Task.start_link(__MODULE__, :fetch, opts)
  end

  def fetch(channel_pid) do
    IO.inspect %{twitter: channel_pid}
  end
end
