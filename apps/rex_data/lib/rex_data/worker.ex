require Logger

defmodule RexData.Worker do
  @moduledoc """
  The Worker context.

  Provides CRUD methods for manipulation of nodes info
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

  @spec list_node :: [Node.t()]
  @doc """
  Returns the list of nodes.
  """
  def list_node,
    do: Repo.all(Node)

  @spec get_node?(node_id) :: Node.t() | nil
  @doc """
  Given the Node ID, returns corresponding node if exists, otherwise `nil`.
  """
  def get_node?(id),
    do: Repo.get(Node, id)

  @doc """
  Creates a node entity with pre-generated Node ID.
  """
  @spec create_node(%{}) :: node_or_error_tuple
  def create_node(payload) do
    payload
    |> Map.put("node_id", Ecto.UUID.generate())

    Node.changeset(%Node{}, payload)
    |> Repo.insert()
  end

  @doc """
  Updates a node.
  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a node.

  ## Examples

      iex> delete_node(node)
      {:ok, %Node{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%Node{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{}

  """
  def change_node(%Node{} = node) do
    Node.changeset(node, %{})
  end

  @doc """
  Returns :ok if given ID exists in database.

  ## Examples

      iex> node_exists?("non_existent")
      false

  """
  @spec node_exists?(String.t()) :: boolean
  def node_exists?(node_id),
    do: Repo.exists?(from node in Node, where: node.node_id == ^node_id)
end
