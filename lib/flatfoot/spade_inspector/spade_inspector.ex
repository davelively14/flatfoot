defmodule Flatfoot.SpadeInspector do
  @moduledoc """
  The boundary for the SpadeInspector system
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Flatfoot.{Repo, Spade}

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
    resp =
      %WardResult{}
      |> ward_result_changeset(attrs)
      |> Repo.insert()


    # Updates last_msg of ward_account
    if attrs |> Map.has_key?(:ward_account_id) do
      ward_account = attrs.ward_account_id |> Spade.get_ward_account

      # If no last_msg or last_msg is before the new msg_id, will update
      if ward_account.last_msg == nil || ward_account.last_msg < attrs.msg_id do
        Spade.update_ward_account(attrs.ward_account_id, %{last_msg: attrs.msg_id})
      end
    end

    resp
  end

  # NOTE can be deprecated in next update
  @doc """
  Returns last ward_result id for a given ward_account_id or nil.

  ## Examples

      iex> get_last_ward_result_msg_id(12)
      11298

      iex> get_last_ward_result_msg_id(0)
      nil
  """
  def get_last_ward_result_msg_id(ward_account_id) do
    results = Repo.all from r in WardResult, where: r.ward_account_id == ^ward_account_id, order_by: [desc: r.timestamp]
    if results != [], do: results |> List.first |> Map.get(:msg_id), else: nil
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

  ##########
  # Server #
  ##########

  alias Flatfoot.SpadeInspector.Server

  @doc """
  Given a valid ward_id, will have SpadeInspector.Server fetch new results for
  the given ward and return it to the SpadeChannel for the owning user.

  ## Examples

      iex> fetch_update(23)
      :ok
  """
  def fetch_update(ward_id) do
    Server.fetch_update(ward_id)
  end

  ##############
  # Changesets #
  ##############

  defp ward_result_changeset(%WardResult{} = ward_result, attrs) do
    ward_result
    |> cast(attrs, [:ward_account_id, :backend_id, :rating, :from, :from_id, :msg_id, :msg_text, :timestamp])
    |> validate_required([:ward_account_id, :backend_id, :rating, :from, :from_id, :msg_id, :msg_text, :timestamp])
    |> validate_inclusion(:rating, 0..100)
  end
end
