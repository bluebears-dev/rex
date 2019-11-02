defmodule Rex.Nodes do
  @moduledoc """
  The Nodes context.
  """
  import Ecto.Query, warn: false
  alias Rex.Repo

  alias Rex.Nodes.{Node, Group}

  @doc """
  Returns the list of node.

  ## Examples

      iex> list_node()
      [%Node{}, ...]

  """
  def list_node do
    Repo.all(Node)
  end

  @doc """
  Gets a single node.

  Raises `Ecto.NoResultsError` if the Node does not exist.

  ## Examples

      iex> get_node!(123)
      %Node{}

      iex> get_node!(456)
      ** (Ecto.NoResultsError)

  """
  def get_node!(id), do: Repo.get!(Node, id)

  @doc """
  Creates a node entity.
  """
  def create_node(payload \\ %{}) do
    new_node = Node.changeset(%Node{}, payload)
    case Repo.get(Group, payload["group_id"]) do
      nil ->
        {:error, %{reason: "Group does not exist"}}
      group ->
        new_node
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:group, group)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a node.Ecto.UUID.generate()

  ## Examples

      iex> update_node(node, %{field: new_value})
      {:ok, %Node{}}

      iex> update_node(node, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_node(%Node{} = node, attrs) do
    node
    |> Node.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Node.

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
      %Ecto.Changeset{source: %Node{}}

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
  def node_exists?(node_id) do
    Repo.exists?(from node in Node, where: node.node_id == ^node_id)
  end

  @doc """
  Returns the list of group.

  ## Examples

      iex> list_group()
      [%Group{}, ...]

  """
  def list_group do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{name: "abcd"})
      {:ok, %Group{}}

      iex> create_group(%{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end
end
