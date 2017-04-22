defmodule Flatfoot.SpadeInspector.Server do
  use GenServer

  defmodule State do
    defstruct sup: nil
  end

  #######
  # API #
  #######

  def start_link(sup) do
    GenServer.start_link(__MODULE__, [sup], name: __MODULE__)
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

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
