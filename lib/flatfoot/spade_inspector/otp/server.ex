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
    GenServer.cast(__MODULE__, {:fetch_update, ward_id})
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

  # For each ward_account (i.e. social media account being monitored), this will
  # asynchronously run an update on all activity to look for warning signs.
  # Returns :noreply. The SpadeInspector will send an update notice to the
  # channel via the pattern "spade:#{user_id}" once it completes analysis on the
  # tweets.
  def handle_cast({:fetch_update, ward_id}, state) do
    ward = Flatfoot.Spade.get_ward_preload!(ward_id)
    config =
      ward.ward_accounts
      |> Enum.map(fn ward_account ->
        %{mfa: {ward_account.backend.module |> String.to_atom, :fetch, [self(), ward.user_id, Query.build(ward_account)]}}
      end)
    Archer.Server.fetch_data(config)
    {:noreply, state}
  end

  def handle_info({:result, user_id, result}, state) do
    {:noreply, state}
  end
end
