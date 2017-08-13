defmodule Flatfoot.SpadeInspector.Server do
  use GenServer
  alias Flatfoot.{SpadeInspector, Archer}

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
    if :ets.info(:modifier_leading) == :undefined, do: :ets.new(:modifier_leading, [:set, :private, :named_table])
    if :ets.info(:modifier_trailing) == :undefined, do: :ets.new(:modifier_trailing, [:set, :private, :named_table])

    load_scoresheet("lib/flatfoot/data/negative_words.csv", :negative_words)
    load_scoresheet("lib/flatfoot/data/modifier_leading.csv", :modifier_leading)
    load_scoresheet("lib/flatfoot/data/modifier_trailing.csv", :modifier_trailing)

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
        last_msg_id = ward_account.last_msg || ""

        %{mfa: {
            ward_account.backend.module |> String.to_atom,
            :fetch,
            [self(), %{user_id: ward.user_id, ward_account_id: ward_account.id, backend_id: ward_account.backend.id}, ward_account.handle, last_msg_id]
          }
        }
      end)
    end

    if configs, do: Archer.fetch_data(configs)
    {:noreply, state}
  end

  # Once the Archer system finishes retrieving the results, it will send the
  # results to this process via the passed pid (see :fetch_update above). This
  # function will parse and store.
  def handle_info({:result, ids, results}, state) do
    results = results |> Enum.map(&add_rating_and_store(&1))

    FlatfootWeb.Endpoint.broadcast("spade:#{ids.user_id}", "new_ward_results", %{ward_results: results})

    {:noreply, state}
  end

  #####################
  # Private Functions #
  #####################

  defp add_rating_and_store(result) do
    rating = result.msg_text |> rate_message()
    {:ok, new_result} = result |> Map.put(:rating, rating) |> store_result
    %{
      id: new_result.id,
      ward_account_id: new_result.ward_account_id,
      backend_id: new_result.backend_id,
      rating: new_result.rating,
      from: new_result.from,
      from_id: new_result.from_id,
      msg_id: new_result.msg_id,
      msg_text: new_result.msg_text,
      timestamp: new_result.timestamp
    }
  end

  # Takes a string, splits it by spaces, removes punctuation, evaluates each
  # word, returns a list of any mentions (people) or hashtags
  defp rate_message(str) do
    split_str = str |> String.split

    rate_message(split_str, "", split_str |> Enum.at(1), 0)
  end

  defp rate_message([], _prev, _next, rating), do: rating
  defp rate_message([head | tail], prev, next, rating) do
    word = standard_word(head)

    result = :ets.lookup(:negative_words, word)

    if result != [] do
      [{_, word_rating}] = result

      prev_result = :ets.lookup(:modifier_leading, (prev || "") |> standard_word)
      next_result = :ets.lookup(:modifier_trailing, (next || "") |> standard_word)

      new_rating =
        cond do
          prev_result != [] && next_result != [] ->
            [{_, prev_rating}] = prev_result
            [{_, next_rating}] = next_result
            rating + (word_rating * word_rating) + (word_rating * prev_rating) + (prev_rating * next_rating)
          prev_result != [] ->
            [{_, prev_rating}] = prev_result
            rating + (word_rating * word_rating) + (word_rating * prev_rating)
          next_result != [] ->
            [{_, next_rating}] = next_result
            rating + (word_rating * word_rating) + (word_rating * next_rating)
          true ->
            rating + (word_rating * word_rating)
        end

      # new_rating = rating + (word_rating * word_rating)

      if new_rating > 99 do
        100
      else
        rate_message(tail, head, tail |> Enum.at(1), new_rating)
      end
    else
      rate_message(tail, head, tail |> Enum.at(1), rating)
    end
  end

  defp store_result(result), do: SpadeInspector.create_ward_result(result)

  defp load_scoresheet(path, table) do
    File.stream!(path)
    |> CSV.decode
    |> Enum.map(fn row ->
      :ets.insert(table, {row |> List.first, row |> List.last |> String.to_integer})
    end)
  end

  defp standard_word(str), do: str |> String.replace(~r/[\p{P}\p{S}]/, "") |> String.downcase
end
