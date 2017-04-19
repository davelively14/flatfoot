defmodule Flatfoot.Archer.Supervisor do
  use Supervisor

  #######
  # API #
  #######

  def start_link(fidos_config) do
    Supervisor.start_link(__MODULE__, fidos_config, name: __MODULE__)
  end

  #############
  # Callbacks #
  #############

  def init(fidos_config) do
    children = [
      supervisor(Flatfoot.Archer.FidoSupervisor, []),
      worker(Flatfoot.Archer.Server, [fidos_config])
    ]

    options = [
      strategy: :one_for_all,
      max_restart: 1,
      max_time: 3600
    ]

    supervise(children, options)
  end
end
