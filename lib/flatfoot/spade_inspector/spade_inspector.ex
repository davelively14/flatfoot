defmodule Flatfoot.SpadeInspector do
  @moduledoc """
  The boundary for the SpadeInspector system
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Flatfoot.Repo

  ###############
  # Ward Result #
  ###############

  alias Flatfoot.SpadeInspector.WardResult

  @doc """
  Creates a ward result with valid params

  ## Examples

      iex> create_ward_result(%{from: "@bully", msg_id: "1234567890", msg_text: "you stink", rating: 25, ward_id: 4, backend_id: 3)
      {:ok, %WardResult{from: "@bully", msg_id: "1234567890", msg_text: "you stink", rating: 25, ward_id: 4, backend_id: 3}}

      iex> create_ward_result(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_ward_result(attrs) do
    %WardResult{}
    |> ward_result_changeset(attrs)
    |> Repo.insert()
  end

  ###########
  # Backend #
  ###########

  alias Flatfoot.SpadeInspector.Backend

  @doc """
  Returns the list of backends.

  ## Examples

      iex> list_backends()
      [%Backend{}, ...]

  """
  def list_backends do
    Repo.all(Backend)
  end

  ##############
  # Changesets #
  ##############

  defp ward_result_changeset(%WardResult{} = ward_result, attrs) do
    ward_result
    |> cast(attrs, [:ward_account_id, :backend_id, :rating, :from, :msg_id, :msg_text])
    |> validate_required([:ward_account_id, :backend_id, :rating, :from, :msg_id, :msg_text])
    |> validate_inclusion(:rating, 0..100)
  end
end
