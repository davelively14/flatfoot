defmodule Flatfoot.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Flatfoot.Repo, []),
      supervisor(FlatfootWeb.Endpoint, []),
      supervisor(Flatfoot.SpadeInspector.SpadeInspectorSupervisor, []),
      supervisor(Flatfoot.Archer.ArcherSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Flatfoot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
