defmodule Flatfoot.SpadeInspector.Server do
  use GenServer
  alias Flatfoot.{SpadeInspector.Query, Archer}

  defmodule InspectorState do
    defstruct sup: nil
  end

  #######
  # API #
  #######

  def start_link(sup) do
    GenServer.start_link(__MODULE__, [sup], name: __MODULE__)
  end

  # Will return the state via the :get_state callback
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  def fetch_update(ward_id) do
    GenServer.call(__MODULE__, {:fetch_update, ward_id})
  end

  #############
  # Callbacks #
  #############

  def init([sup]) do
    state = %InspectorState{sup: sup}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:fetch_update, ward_id}, _from, state) do
    ward = Flatfoot.Spade.get_ward_preload!(ward_id)
    config =
      ward.ward_accounts
      |> Enum.map(fn ward_account ->
        %{mfa: {ward_account.backend.module, :fetch, [self(), Query.build(ward_account)]}}
      end)
    Archer.Server.fetch_data(config)
    {:noreply, state}
  end
end
