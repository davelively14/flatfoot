defmodule Flatfoot.Archer.ArcherSupervisor do
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
    children = [
      supervisor(Task.Supervisor, [[name: Flatfoot.Archer.FidoSupervisor]]),
      worker(Flatfoot.Archer.Server, [ self() ])
    ]

    options = [
      strategy: :one_for_all,
      max_restart: 1,
      max_time: 3600
    ]

    supervise(children, options)
  end
end
