require Logger

defmodule RexData.Project do
  @moduledoc """
  The Project context.
  Contains both project and task schemes along with related methods.
  """
  @default_fragments_dir "./fragments"

  import Ecto.Query, warn: false

  alias RexData.{FileManager, Repo, FilenameGenerator}
  alias RexData.Project.{ProjectInfo, Task}

  @doc """
  Gets a single project or `nil` if project with given ID does not exist.
  """
  @spec get_project(String.t()) :: %ProjectInfo{} | nil
  def get_project(id),
    do: Repo.get(ProjectInfo, id)

  @doc """
  Creates and saves a new project. It goes by:

    * staging data in a changeset
    * copying file provided by the user (project binary file)
    * finally persisting data in the database

  If it fails in any step, the data isn't persisted.

  Third argument serves as a dependency injection for testing purposes.
  It defaults to `File` module and should be left unchanged in most cases.

  The path to the copied file will be created if it does not exist.
  Furthermore, the path is ensured to be uniquely generated for every new project.
  """
  @spec insert_new_project(map, Path.t(), any) :: {:ok, %ProjectInfo{}} | {:error, any}
  def insert_new_project(payload, file_path, file_dependency \\ File) do
    project_changeset = create_project(payload)

    with new_path <- Ecto.Changeset.fetch_field!(project_changeset, :path),
         :ok <- FileManager.copy_file(file_path, new_path, file_dependency) do
      Repo.insert(project_changeset)
    end
  end

  @doc """
  Creates a project entity.
  Ensures that path (to the project file) is uniquely generated.
  """
  @spec create_project(map) :: Ecto.Changeset.t()
  def create_project(payload) do
    filename_gen = FilenameGenerator.get()
    filename = filename_gen.generate_filename(".blend")
    Logger.debug("Creating new project with: #{inspect(payload)}")

    payload
    |> Map.put(:path, filename)
    |> ProjectInfo.new()
  end

  @doc """
  Saves the rendered fragment to the filesystem.
  """
  @spec save_fragment(%Task{}, %Plug.Upload{}) :: :ok | :error
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
          :ok | {:error, String.t(), atom}
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
    # TODO violated SR - should take changeset instead and modify it properly
    case get_project(id) do
      nil ->
        {:error, "No project of #{id} has been found", :not_found}

      project ->
        update_project_state(project, :canceled)
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

  @spec start_project(%ProjectInfo{}) :: any
  def start_project(project), do: update_project_state(project, :in_progress)

  @doc """
  Returns the list of tasks for given project id.
  """
  @spec list_task(binary) :: list(%Task{})
  def list_task(project_id) do
    Ecto.Query.from(
      task in Task,
      where: task.project == ^project_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single task or nil.
  """
  @spec get_task(integer) :: %Task{}
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
  """
  @spec first_free_task(binary) :: %Task{}
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

  defp update_project_state(project, state) do
    project
    |> ProjectInfo.changeset(%{state: state})
    |> Repo.update()
  end
end
