defmodule Flatfoot.Archer.Server do
  use GenServer
  alias Flatfoot.Archer.{FidoSupervisor}

  defmodule ArcherState do
    defstruct sup: nil
  end

  #######
  # API #
  #######

  def start_link(sup) do
    GenServer.start_link(__MODULE__, [sup], name: __MODULE__)
  end

  @doc """
  Starts a fido worker with the proper config.


  ## Examples

    iex> config =
    iex> [
    iex> mfa: {Archer.Twitter, :start_link, [return_pid, ids_map, handle, last_msg_id]},
    iex> mfa: {Archer.Facebook, :start_link, [return_pid, ids_map, handle, last_msg_id]}
    iex> ]
    [mfa: {Archer.Twitter, :start_link, [#PID<0.659.0>, %{...}, "@handle", "234242"]}, mfa: {Archer.Facebook, :start_link, [#PID<0.659.0>, %{...}, "username", "123"]}]
    iex> fetch_data(config)


  """
  def fetch_data(config) do
    GenServer.cast(__MODULE__, {:fetch_data, config})
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  #############
  # Callbacks #
  #############

  def init([sup]) do
    state = %ArcherState{sup: sup}
    {:ok, state}
  end

  # Receives a list of mfa configs, in this case from the SpadeInspector
  # :fetch_update call. This function will call the private function
  # dispatch_fido, which takes a list of configs and asynchronously instructs
  # the FidoSupervisor to spawn backend workers that will each fetch the data.
  def handle_cast({:fetch_data, configs}, state) do
    dispatch_fido(configs)
    {:noreply, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  #####################
  # Private Functions #
  #####################

  defp dispatch_fido([]), do: nil
  defp dispatch_fido([config | tail]) do
    {mod, fun, args} = config.mfa

    # Task.Supervisor.start_child/4 provides a supervisor, module, function for
    # that module, and any arguments in a list. Note that FidoSupervisor only
    # exists as a named Task.Supervisor child within ArcherSupervisor - you
    # won't find a separate fido_supervisor.ex.
    {:ok, _pid} = Task.Supervisor.start_child(FidoSupervisor, mod, fun, args)
    dispatch_fido(tail)
  end
end
