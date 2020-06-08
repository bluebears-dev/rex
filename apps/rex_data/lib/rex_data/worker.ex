require Logger

defmodule RexData.Worker do
  @moduledoc """
  The Worker context.

  Provides some of the CRUD methods for manipulation of nodes info.
  """
  import Ecto.Query, warn: false

  alias RexData.Repo
  alias RexData.Worker.Node

  @typedoc """
  Alias for the Ecto.UUID type used as the Node ID.
  """
  @type node_id :: Ecto.UUID.t()

  @typedoc """
  Alias describing possible failure during validation. Tuple containing either a `Node` or `Changeset`.
  """
  @type node_or_error_tuple :: {:ok, Node.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Given the Node ID, returns corresponding node if exists, otherwise `nil`.
  """
  @spec get_node?(node_id) :: Node.t() | nil
  def get_node?(id),
    do: Repo.get(Node, id)

  @doc """
  Creates a node entity with pre-generated Node ID.
  """
  @spec create_node(%{}) :: node_or_error_tuple
  def create_node(payload) do
    payload = payload
    |> Map.put(:node_id, Ecto.UUID.generate())

    Node.changeset(%Node{}, payload)
    |> Repo.insert()
  end
end
