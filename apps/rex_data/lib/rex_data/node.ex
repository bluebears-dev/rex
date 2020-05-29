require Logger

defmodule RexData.Node do
  @moduledoc """
  The Nodes context.
  """
  import Ecto.Query, warn: false

  alias RexData.Repo
  alias RexData.Node.NodeInfo

  @doc """
  Returns the list of node.

  ## Examples"

      iex> list_node()
      [%NodeInfo{}, ...]

  """
  def list_node,
    do: Repo.all(NodeInfo)

  @doc """
  Gets a single node or nil.

  ## Examples

      iex> get_node(123)
      %Node{}

      iex> get_node(456)
      nil

  """
  def get_node(id),
    do: Repo.get(Node, id)

  @doc """
  Creates a node entity.
  """
  def create_node(payload) do
    NodeInfo.changeset(%NodeInfo{}, payload)
    |> Repo.insert()
  end

  @doc """
  Updates a node.Ecto.UUID.generate()

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%NodeInfo{} = node, attrs) do
    node
    |> NodeInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Node.

  ## Examples

      iex> delete_node(node)
      {:ok, %NodeInfo{}}

      iex> delete_node(node)
      {:error, %Ecto.Changeset{}}

  """
  def delete_node(%NodeInfo{} = node) do
    Repo.delete(node)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking node changes.

  ## Examples

      iex> change_node(node)
      %Ecto.Changeset{source: %Node{}}

  """
  def change_node(%NodeInfo{} = node) do
    NodeInfo.changeset(node, %{})
  end

  @doc """
  Returns :ok if given ID exists in database.

  ## Examples

      iex> node_exists?("non_existent")
      false

  """
  @spec node_exists?(String.t()) :: boolean
  def node_exists?(node_id),
    do: Repo.exists?(from node in NodeInfo, where: node.node_id == ^node_id)
end
