defmodule Flatfoot.Archer do
  @moduledoc """
  The boundary for the Clients system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Flatfoot.Repo

  ###########
  # Backend #
  ###########

  alias Flatfoot.Archer.Backend

  @doc """
  Returns the list of backends.

  ## Examples

      iex> list_backends()
      [%Backend{}, ...]

  """
  def list_backends do
    Repo.all(Backend)
  end

  @doc """
  Gets a single backend.

  Raises `Ecto.NoResultsError` if the Backend does not exist.

  ## Examples

      iex> get_backend!(123)
      %Backend{}

      iex> get_backend!(456)
      ** (Ecto.NoResultsError)

  """
  def get_backend!(id), do: Repo.get!(Backend, id)

  @doc """
  Creates a backend. Note that the module and name_snake are created by the app.

  ## Examples

      iex> create_backend(%{name: "Twitter", url: "https://www.twitter.com")
      {:ok, %Backend{name: "Twitter, url: "https://www.twitter.com", name_snake: "twitter", "Elixir.Flatfoot.Archer.Twitter"}}

      iex> create_backend(%{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_backend(attrs) do
    %Backend{}
    |> backend_changeset(attrs)
    |> Repo.insert()
  end

  ##############
  # Changesets #
  ##############

  defp backend_changeset(%Backend{} = backend, attrs) do
    backend
    |> cast(attrs, [:name, :url])
    |> validate_required([:name, :url])
    |> add_snake_and_module
  end

  ##########
  # Server #
  ##########

  alias Flatfoot.Archer.Server

  @doc """
  Will send configs to the Archer.Server module to schedule for fetching.

  ## Examples

      iex> fetch_data(configs)
      :ok
  """
  def fetch_data(configs) do
    Server.fetch_data(configs)
  end

  #####################
  # Private Functions #
  #####################

  defp add_snake_and_module(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        name_snake = name |> String.downcase |> String.replace(" ", "_")
        name_camel = name |> String.split(" ") |> Enum.map(&String.capitalize/1) |> List.to_string

        changeset
        |> put_change(:name_snake, name_snake)
        |> put_change(:module, "Elixir.Flatfoot.Archer.Backend.#{name_camel}")
      _ ->
        changeset
    end
  end
end
