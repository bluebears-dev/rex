require Logger

defmodule RexData.Project do
  @moduledoc """
  The Project context.
  Contains both project and task schemes along with related methods.
  """
  @default_project_dir "./project_files"
  @default_fragments_dir "./fragments"

  import Ecto.Query, warn: false

  alias RexData.Repo
  alias RexData.Project.{ProjectInfo, Task}

  @doc """
  Gets a single project or nil.

  ## Examples

      iex> get_project(123)
      %Project{}

      iex> get_project(456)
      nil

  """
  def get_project(id),
    do: Repo.get(ProjectInfo, id)

  @doc """
  Creates a project entity.
  """
  def create_project(payload \\ %{}) do
    filename = "#{@default_project_dir}/#{Ecto.UUID.generate()}.blend"

    case validate_and_copy_file(filename, payload["project"], "blend") do
      :ok ->
        valid_payload =
          payload
          |> Map.drop([:state])
          |> Map.put("path", filename)

        ProjectInfo.changeset(%ProjectInfo{}, valid_payload)
        |> Repo.insert()

      error ->
        error
    end
  end

  @doc """
  Saves the rendered fragment to the filesystem.
  """
  @spec save_fragment(Task.t(), %Plug.Upload{}) :: :ok | :error
  def save_fragment(task, payload) do
    path = "#{@default_fragments_dir}/#{task.project}/#{task.frame}.png"

    case validate_and_copy_file(path, payload, "png") do
      :ok ->
        path

      error ->
        error
    end
  end

  @spec validate_and_copy_file(String.t(), %Plug.Upload{}, String.t()) ::
          :ok | {:error, atom, atom}
  defp validate_and_copy_file(
         new_path,
         %Plug.Upload{path: path, filename: filename},
         expected_format
       ) do
    extension = Path.extname(filename)
    Logger.info("Saving frame: #{new_path}")

    # Perhaps validate it properly
    with "." <> ^expected_format <- extension,
         :ok <- File.mkdir_p(Path.dirname(new_path)),
         :ok <- File.cp(path, new_path) do
      :ok
    else
      {:error, result} -> {:error, "Failed when trying to save file #{result}", :bad_request}
    end
  end

  defp validate_and_copy_file(_new_path, _upload, _expected_format),
    do: {:error, "Received invalid data", :bad_request}

  @doc """
  Cancel a project entity.
  """
  def cancel_project(id) do
    case get_project(id) do
      nil ->
        {:error, "No project of #{id} has been found", :not_found}

      project ->
        project
        |> ProjectInfo.changeset(%{state: :canceled})
        |> Repo.update()
    end
  end

  @doc """
  Gets next queued project.
  """
  def next_project do
    Ecto.Query.from(
      project in ProjectInfo,
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
  def update_project(%ProjectInfo{} = project, attrs) do
    project
    |> ProjectInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns the list of tasks for given project id.

  ## Examples

      iex> list_task(1)
      [%Task{}, ...]

  """
  @spec list_task(binary) :: list(Task.t())
  def list_task(project_id) do
    Ecto.Query.from(
      task in Task,
      where: task.project == ^project_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single task or nil.

  ## Examples

      iex> get_task(123)
      %Task{}

      iex> get_task(456)
      nil

  """
  @spec get_task(integer) :: Task.t()
  def get_task(id),
    do: Repo.get(Task, id)

  @doc """
  Creates a task entity.
  """
  def create_task(payload) do
    Task.changeset(%Task{}, payload)
    |> Repo.insert()
  end

  @doc """
  Updates a task entity.
  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Batch creates tasks from the list.
  """
  def batch_create_task(payloads) do
    alias Ecto.Multi

    payloads
    |> Enum.reduce(Multi.new(), fn task, multi ->
      Multi.insert(multi, {:insert, task.frame}, Task.changeset(%Task{}, task))
    end)
    |> Repo.transaction()
  end

  @doc """
  Returns the first free tasks.

  ## Examples

      iex> first_free_task(1)
      %Task{}

  """
  @spec first_free_task(binary) :: Task.t()
  def first_free_task(project_id) do
    Ecto.Query.from(
      task in Task,
      where: task.project == ^project_id,
      where: is_nil(task.node),
      order_by: [desc: :inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  def list_complete_task(project_id) do
    Ecto.Query.from(
      task in Task,
      where: task.project == ^project_id,
      where: not is_nil(task.path),
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
  end

  def get_task_by_project(project_id, frame) do
    Ecto.Query.from(
      task in Task,
      where: task.project == ^project_id,
      where: task.frame == ^frame,
      limit: 1
    )
    |> Repo.one()
  end
end
