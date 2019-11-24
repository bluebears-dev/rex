require Logger

defmodule Rex.Entity do
  @moduledoc """
  The Nodes context.
  """
  @default_dir "project_files"

  import Ecto.Query, warn: false
  alias Rex.Repo

  alias Rex.Entity.{Node, Project}

  @doc """
  Returns the list of node.

  ## Examples"

      iex> list_node()
      [%Node{}, ...]

  """
  def list_node do
    Repo.all(Node)
  end

  @doc """
  Gets a single node or nil.

  ## Examples

      iex> get_node(123)
      %Node{}

      iex> get_node(456)
      nil

  """
  def get_node(id), do: Repo.get(Node, id)

  @doc """
  Creates a node entity.
  """
  def create_node(payload) do
    new_node = Node.changeset(%Node{}, payload)
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
  Gets a single project or nil.

  ## Examples

      iex> get_project(123)
      %Project{}

      iex> get_project(456)
      nil

  """
  def get_project(id), do: Repo.get(Project, id)

  @doc """
  Creates a project entity.
  """
  def create_project(payload \\ %{}) do
    filename = "#{@default_dir}/#{Ecto.UUID.generate()}.blend"
    case copy_project_file(filename, payload["project"]) do
      :ok ->
        valid_payload = payload
                        |> Map.drop([:state])
                        |> Map.put("filename", filename)

        Project.changeset(%Project{}, valid_payload)
        |> Repo.insert()
      error -> error
    end
  end

  @doc """
  Copies file into projects directory.
  """
  @spec copy_project_file(String.t(), %Plug.Upload{}) :: :ok | {:error, atom}
  defp copy_project_file(new_path, %Plug.Upload{path: path, filename: filename}) do
    extension = Path.extname(filename)
    if extension === ".blend" do
      File.cp(path, new_path)
      :ok
    else
      {:error, "Received file was not the .blend file"}
    end
  end

  defp copy_project_file(_new_path, _upload),
       do: {:error, "Received invalid data"}

  @doc """
  Cancel a project entity.
  """
  def cancel_project(id) do
    case get_project(id) do
      nil ->
        {:error, "No project of #{id} has been found"}
      project ->
        project
        |> Project.changeset(%{state: :canceled})
        |> Repo.update()
    end
  end

  @doc """
  Gets next queued project.
  """
  def next_project do
    Ecto.Query.from(
      project in Project,
      where: project.state == ^:queued,
      order_by: [
        desc: project.inserted_at
      ],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Updates a project.
  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end
  #  @doc """
  #  Returns the list of group.
  #
  #  ## Examples
  #
  #      iex> list_group()
  #      [%Group{}, ...]
  #
  #  """
  #  def list_group do
  #    Repo.all(Group)
  #  end
  #
  #  @doc """
  #  Gets a single group.
  #
  #  Raises `Ecto.NoResultsError` if the Group does not exist.
  #
  #  ## Examples
  #
  #      iex> get_group!(123)
  #      %Group{}
  #
  #      iex> get_group!(456)
  #      ** (Ecto.NoResultsError)
  #
  #  """
  #  def get_group!(id), do: Repo.get!(Group, id)
  #
  #  @doc """
  #  Creates a group.
  #
  #  ## Examples
  #
  #      iex> create_group(%{name: "abcd"})
  #      {:ok, %Group{}}
  #
  #      iex> create_group(%{name: nil})
  #      {:error, %Ecto.Changeset{}}
  #
  #  """
  #  def create_group(attrs \\ %{}) do
  #    %Group{}
  #    |> Group.changeset(attrs)
  #    |> Repo.insert()
  #  end
  #
  #  @doc """
  #  Updates a group.
  #
  #  ## Examples
  #
  #      iex> update_group(group, %{field: new_value})
  #      {:ok, %Group{}}
  #
  #      iex> update_group(group, %{field: bad_value})
  #      {:error, %Ecto.Changeset{}}
  #
  #  """
  #  def update_group(%Group{} = group, attrs) do
  #    group
  #    |> Group.changeset(attrs)
  #    |> Repo.update()
  #  end
  #
  #  @doc """
  #  Deletes a Group.
  #
  #  ## Examples
  #
  #      iex> delete_group(group)
  #      {:ok, %Group{}}
  #
  #      iex> delete_group(group)
  #      {:error, %Ecto.Changeset{}}
  #
  #  """
  #  def delete_group(%Group{} = group) do
  #    Repo.delete(group)
  #  end
  #
  #  @doc """
  #  Returns an `%Ecto.Changeset{}` for tracking group changes.
  #
  #  ## Examples
  #
  #      iex> change_group(group)
  #      %Ecto.Changeset{source: %Group{}}
  #
  #  """
  #  def change_group(%Group{} = group) do
  #    Group.changeset(group, %{})
  #  end
end
