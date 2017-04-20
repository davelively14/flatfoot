defmodule Flatfoot.Archer.Server do
  use GenServer
  import Supervisor.Spec

  defmodule State do
    defstruct fido_sup: nil
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
    iex> mfa: {Archer.Twitter, :start_link, [channel: pid]},
    iex> mfa: {Archer.Facebook, :start_link, [channel: pid]}
    iex> ]
    [mfa: {Archer.Twitter, :start_link, [channel: pid]}, mfa: {Archer.Facebook, :start_link, [channel: pid]}]
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

  def init(fido_sup) do
    state = %State{fido_sup: fido_sup}
    {:ok, state}
  end

  def handle_cast({:fetch_data, config}, %{fido_sup: fido_sup} = state) do
    dispatch_fido(fido_sup, config)

    {:no_reply, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  #####################
  # Private Functions #
  #####################

  defp dispatch_fido(_, []), do: nil
  defp dispatch_fido(fido_sup, [config | tail]) do
    Supervisor.start_child(fido_sup, fido_spec(config))
    dispatch_fido(fido_sup, tail)
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
