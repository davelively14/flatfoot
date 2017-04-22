defmodule Flatfoot.Archer.Server do
  use GenServer
  alias Flatfoot.Archer.{FidoSupervisor}

  defmodule State do
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
    iex> mfa: {Archer.Twitter, :start_link, [channel_pid]},
    iex> mfa: {Archer.Facebook, :start_link, [channel_pid]}
    iex> ]
    [mfa: {Archer.Twitter, :start_link, [channel_pid]}, mfa: {Archer.Facebook, :start_link, [channel_pid]}]
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
    state = %State{sup: sup}
    {:ok, state}
  end

  def handle_cast({:fetch_data, config}, state) do
    dispatch_fido(config)
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

    {:ok, _pid} = Task.Supervisor.start_child(FidoSupervisor, mod, fun, args)
    dispatch_fido(tail)
  end
end
