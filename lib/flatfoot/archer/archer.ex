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
end
