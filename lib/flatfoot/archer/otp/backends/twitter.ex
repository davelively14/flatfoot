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
  def fetch(from, ids, query) when is_pid(from) and is_map(ids) and is_map(query) do
    url = query |> build_url
    headers = ["Authorization": "Bearer #{@token}"]
    {:ok, result} = HTTPoison.get(url, headers)
    send(from, {:result, ids, result |> Map.get(:body) |> Poison.decode!})
  end

  #####################
  # Private Functions #
  #####################

  defp build_url(query) do
    search_term = query |> URI.encode_query()
    "https://api.twitter.com/1.1/search/tweets.json?#{search_term}"
  end
end
