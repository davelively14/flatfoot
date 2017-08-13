defmodule FlatfootWeb.PageController do
  use FlatfootWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
