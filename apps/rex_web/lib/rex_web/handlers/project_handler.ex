require Logger

defmodule RexWeb.ProjectHandler do
  require RexWeb.Events

  alias RexData.Project
  alias RexData.Project.ProjectInfo
  alias RexData.State
  alias RexWeb.{Endpoint, Events}

  def handle_new(payload) do
    with {:ok, _project} <- Project.create_project(payload),
         {:ok, started_project} <- start_new_project() do
      response = %{project_id: started_project.id}
      {:ok, response}
    end
  end

  def handle_cancel(id),
    do: Project.cancel_project(id)

  @spec handle_download(any) :: {:ok, any} | {:error, <<_::64, _::_*8>>, :not_found}
  def handle_download(id) do
    case Project.get_project(id) do
      nil ->
        {:error, "Project #{id} has not been found", :not_found}

      %ProjectInfo{path: path} ->
        {:ok, path}
    end
  end

  @spec get_current_project() :: ProjectInfo.t()
  def get_current_project() do
    with {:ok, response} <- State.get_state(),
         %{project: project} <- response,
         %{state: :in_progress} <- project do
      project
    else
      _ ->
        nil
    end
  end

  @spec split_project(ProjectInfo.t()) :: any
  def split_project(project) do
    Logger.debug("Splitting project to #{project.total_frames} tasks")

    Enum.map(0..(project.total_frames - 1), fn val ->
      %{
        frame: val + project.starting_frame,
        path: nil,
        node: nil,
        project: project.id
      }
    end)
    |> Project.batch_create_task()
  end

  @spec start_new_project() :: {:ok, ProjectInfo.t()} | {:warn, binary} | {:error, binary}
  def start_new_project() do
    with nil <- get_current_project(),
         project when project != nil <- Project.next_project(),
         {:ok, new_project} = response = Project.update_project(project, %{state: :in_progress}) do
      {:ok, _result} = split_project(project)
      State.start_new_project(new_project)

      Logger.debug("Broadcasting info about new project")

      Endpoint.broadcast!(
        "worker:rendering",
        Events.new_project(),
        %{project_id: new_project.id}
      )

      response
    else
      {:error, _, _, _, _, _} -> {:error, "Invalid data"}
      nil -> {:error, "No queued projects"}
      response -> {:warn, response}
    end
  end

  @spec close_project() :: :ok | :error
  def close_project() do
    State
  end

  def handle_project_status(project_id) do
    with all_tasks when is_list(all_tasks) <- Project.list_task(project_id),
         complete_tasks when is_list(complete_tasks) <- Project.list_complete_task(project_id) do
      all_tasks_count = Enum.count(all_tasks)

      if all_tasks_count > 0 do
        {:ok,
         %{
           all: Enum.count(all_tasks),
           complete: Enum.count(complete_tasks)
         }}
      else
        {:error, "Project not found", :not_found}
      end
    else
      error -> error
    end
  end

  def start_next_project() do
    with {:ok, _} <- State.close_project() do
      start_new_project()
    end
  end
end
