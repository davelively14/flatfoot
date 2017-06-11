defmodule Flatfoot.SpadeInspector.Server do
  use GenServer
  alias Flatfoot.{SpadeInspector, SpadeInspector.Query, Archer}

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

  def get_rating(str) do
    GenServer.call(__MODULE__, {:get_rating, str})
  end

  def fetch_update(ward_id) do
    GenServer.cast(__MODULE__, {:fetch_update, ward_id})
  end

  #############
  # Callbacks #
  #############

  # Inits state and loads the negative words library into an :ets table
  def init([sup]) do
    if :ets.info(:negative_words) == :undefined, do: :ets.new(:negative_words, [:set, :private, :named_table])

    # TODO: see if we can avoid two iterations of the list (ie not Enum.map |> List.foldl)
    # negative_words_map =
    File.stream!("lib/flatfoot/data/negative_words.csv")
    |> CSV.decode
    |> Enum.map(fn row ->
      :ets.insert(:negative_words, {row |> List.first, row |> List.last |> String.to_integer})
    end)
      # |> Enum.map(&(&1))
      # |> List.foldl(%{}, fn row, map ->
      #   Map.put(map, row |> List.first, row |> List.last |> String.to_integer)
      # end)
      # |> Enum.each(:ets.insert(:negative_words, ))

    state = %InspectorState{sup: sup}
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_rating, str}, _from, state) do
    {:reply, rate_message(str), state}
  end

  # When a client subscribed to a SpadeChannel calls the fetch_new_ward_results
  # and passes a ward_id, the channel will call this function.
  #
  # For each ward_account (i.e. social media account being monitored) that
  # belongs to the passed ward_id, this function will create an mfa config. This
  # function will then pass the list of configs to the Archer system via the
  # server call "fetch_data".
  #
  # Note: mfa stands for (m)odule, (f)unction, and (a)rguments. The module is
  # the backend module to be called, the function is the function to be called
  # on the module, and arguments is a list of parameters: pid for reutrn
  # callback, a map of required ids (user_id, ward_account_id, and backend_id),
  # and the query (i.e. search parameters) to be sent to the backend.
  def handle_cast({:fetch_update, ward_id}, state) do
    configs = if ward = Flatfoot.Spade.get_ward_preload(ward_id) do
      ward.ward_accounts |> Enum.map(fn ward_account ->
        %{mfa: {
            ward_account.backend.module |> String.to_atom,
            :fetch,
            [self(), %{user_id: ward.user_id, ward_account_id: ward_account.id, backend_id: ward_account.backend.id}, Query.build(ward_account)]
          }
        }
      end)
    end

    if configs, do: Archer.Server.fetch_data(configs)
    {:noreply, state}
  end

  # Once the Archer system finishes retrieving the results, it will send the
  # results to this process via the passed pid (see :fetch_update above). This
  # function will parse and store.
  # TODO: move result logic to Twitter. Twitter should return complete results map.
  def handle_info({:result, ids, result}, state) do

    results =
      result |> Map.get("statuses") |> Enum.map(fn status ->
        %{
          ward_account_id: ids.ward_account_id,
          backend_id: ids.backend_id,
          rating: 0,
          from: Enum.join(["@", status |> Map.get("user") |> Map.get("screen_name")], ""),
          from_id: status |> Map.get("user") |> Map.get("id_str"),
          msg_id: status |> Map.get("id_str"),
          msg_text: status |> Map.get("text")
        }
      end)

    results |> Enum.each(&parse_and_store_result(&1))

    Flatfoot.Web.Endpoint.broadcast("spade:#{ids.user_id}", "new_ward_results", %{results: results})

    {:noreply, state}
  end

  #####################
  # Private Functions #
  #####################

  defp parse_and_store_result(result) do
    rating = result.msg_text |> rate_message()
    result |> Map.put(:rating, rating) |> store_result
  end

  # Takes a string, splits it by spaces, removes punctuation, evaluates each
  # word, returns a list of any mentions (people) or hashtags
  defp rate_message(str), do: rate_message(str |> String.split, 0)
  defp rate_message([], rating), do: rating
  defp rate_message([head | tail], rating) do
    word = head |> String.replace(~r/[\p{P}\p{S}]/, "") |> String.downcase

    if :ets.lookup(:negative_words, word) != [] do
      [{_, word_rating}] = :ets.lookup(:negative_words, word)
      new_rating = rating + (word_rating * word_rating)

      if new_rating > 99 do
        100
      else
        rate_message(tail, new_rating)
      end
    else
      rate_message(tail, rating)
    end
  end

  defp store_result(result), do: SpadeInspector.create_ward_result(result)
end
