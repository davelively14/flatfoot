defmodule Flatfoot.SpadeInspector.SpadeInspectorSupervisor do
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
      worker(Flatfoot.SpadeInspector.Server, [ self() ])
    ]

    options = [
      strategy: :one_for_all,
      max_restart: 1,
      max_time: 3600
    ]

    supervise(children, options)
  end
end
