require Logger

defmodule RexWeb.ProjectHandler do
  require RexWeb.Events
  alias Rex.{Entity, Manager}
  alias RexWeb.{Endpoint, Events}

  def handle_new(payload) do
    with {:ok, _project} <- Entity.create_project(payload),
         {:ok, started_project} <- start_new_project() do
      response = %{project_id: started_project.id}

      Logger.debug("Broadcasting info about new project")

      Endpoint.broadcast!(
        "worker:rendering",
        Events.new_project(),
        response
      )

      {:ok, response}
    end
  end

  def handle_cancel(id),
    do: Entity.cancel_project(id)

  def handle_download(id) do
    case Entity.get_project(id) do
      nil ->
        {:error, "Project #{id} has not been found", :not_found}

      %Entity.Project{path: path} ->
        {:ok, path}
    end
  end

  @spec get_current_project() :: Entity.Project.t()
  def get_current_project() do
    with {:ok, response} <- Manager.get_state(),
         %{project: project} <- response,
         %{state: :in_progress} <- project do
      project
    else
      _ ->
        nil
    end
  end

  @spec split_project(Entity.Project.t()) :: any
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
    |> Entity.batch_create_task()
  end

  @spec start_new_project() :: {:ok, Entity.Project.t()} | {:warn, binary} | {:error, binary}
  def start_new_project() do
    with nil <- get_current_project(),
         project when project != nil <- Entity.next_project(),
         {:ok, new_project} = response = Entity.update_project(project, %{state: :in_progress}) do
      {:ok, _result} = split_project(project)
      Manager.start_new_project(new_project)
      response
    else
      {:error, _, _, _, _, _} -> {:error, "Invalid data"}
      nil -> {:error, "No queued projects"}
      response -> {:warn, response}
    end
  end

  def handle_project_status(project_id) do
    with all_tasks when is_list(all_tasks) <- Entity.list_task(project_id),
         complete_tasks when is_list(complete_tasks) <- Entity.list_complete_task(project_id) do
      {:ok,
       %{
         all: Enum.count(all_tasks),
         complete: Enum.count(complete_tasks)
       }}
    else
      error -> Logger.debug("#{inspect error}")
    end
  end
end
