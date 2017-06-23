defmodule Flatfoot.Archer.Backend.Twitter do

  @token Application.get_env(:flatfoot, :twitter)[:token]

  #######
  # API #
  #######

  @doc """
  Provided a from, the user_id and a query, will return the results from Twitter's API in JSON format.

  query should be a map with the following parameters:
  %{q: "search string"}
  """
  def fetch(from, ids, handle, last) when is_pid(from) and is_map(ids) and is_bitstring(handle) and is_bitstring(last) do
    url = {handle, last} |> build_query |> build_url
    headers = ["Authorization": "Bearer #{@token}"]
    {:ok, body} = HTTPoison.get(url, headers)
    parsed_results = body |> Map.get(:body) |> Poison.decode! |> parse_body(ids)
    send(from, {:result, ids, parsed_results})
  end

  #####################
  # Private Functions #
  #####################

  defp build_query({handle, last}) do
    # %{q: handle, since_id: last}
    %{q: "#{handle} OR from:#{handle} -filter:retweets", since_id: last, count: 100}
  end

  defp build_url(query) do
    search_term = query |> URI.encode_query()
    "https://api.twitter.com/1.1/search/tweets.json?#{search_term}"
  end
  # defp build_url(query) do
  #   search_term = query |> URI.encode_query()
  #   "https://api.twitter.com/1.1/statuses/user_timeline.json?#{search_term}"
  # end

  defp parse_body(body, ids) do
    body |> Map.get("statuses") |> Enum.map(fn status ->
      %{
        ward_account_id: ids.ward_account_id,
        backend_id: ids.backend_id,
        rating: 0,
        from: Enum.join(["@", status |> Map.get("user") |> Map.get("screen_name")], ""),
        from_id: status |> Map.get("user") |> Map.get("id_str"),
        msg_id: status |> Map.get("id_str"),
        msg_text: status |> Map.get("text"),
        timestamp: status |> Map.get("created_at") |> parse_date_time
      }
    end)
  end

  defp parse_date_time(str) do
    months = %{"Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12}

    month = months |> Map.get(str |> String.slice(4..6))
    day = str |> String.slice(8..9) |> String.to_integer
    year = str |> String.slice(26..29) |> String.to_integer
    hour = str |> String.slice(11..12) |> String.to_integer
    minute = str |> String.slice(14..15) |> String.to_integer
    second = str |> String.slice(17..18) |> String.to_integer

    Ecto.DateTime.cast(%{year: year, month: month, day: day, hour: hour, minute: minute, second: second}) |> elem(1)
  end
end
