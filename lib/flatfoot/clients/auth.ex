defmodule Flatfoot.Clients.Auth do
  import Plug.Conn
  alias Flatfoot.Clients

  def init(options) do
    options
  end

  def call(conn, _opts) do
    case find_user(conn) do
      {:ok, user} ->
        token = Phoenix.Token.sign(conn, "user socket", user.id)

        conn
        |> assign(:ws_token, token)
        |> assign(:current_user, user)
      _ -> auth_error!(conn)
    end
  end

  #####################
  # Private Functions #
  #####################

  defp find_user(conn) do
    with auth_header = get_req_header(conn, "authorization"),
      {:ok, token} <- parse_token(auth_header),
      {:ok, session} <- get_session(token),
    do: {:ok, Clients.get_user_by_session(session)}
  end

  defp parse_token(["Token token=" <> token]), do: {:ok, String.replace(token, "\"", "")}
  defp parse_token(_), do: :error

  defp get_session(token) do
    case session = Clients.get_session_by_token(token) do
      nil -> :error_handler
      _ -> {:ok, session}
    end
  end

  defp auth_error!(conn) do
    conn |> put_status(:unauthorized) |> halt()
  end
end
