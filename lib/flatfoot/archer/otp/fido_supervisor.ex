defmodule Flatfoot.Archer.FidoSupervisor do
  use Supervisor

  #######
  # API #
  #######

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #############
  # Callbacks #
  #############

  def init(_) do
    options = [ strategy: :one_for_one, restart: :transient ]
    supervise([], options)
  end
end
