defmodule Flatfoot.Archer.Server do
  use GenServer
  import Supervisor.Spec
  alias Flatfoot.Archer.FidoSupervisor

  defmodule State do
    defstruct sup: nil
  end

  #######
  # API #
  #######

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
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

  def init(sup) do
    state = %State{sup: sup}
    {:ok, state}
  end

  def handle_cast({:fetch_data, config}, %{sup: sup} = state) do
    IO.inspect %{server_pid: self()}
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
    Supervisor.start_child(FidoSupervisor, fido_spec(config))
    dispatch_fido(tail)
  end

  defp fido_spec(config) do
    {module, function, attributes} = config.mfa

    options = [
      id:  System.unique_integer(),
      function: function,
      restart: :transient
    ]

    worker(module, attributes, options)
  end
end
