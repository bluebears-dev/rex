require Logger

defmodule RexWeb.TaskHandler do
  @moduledoc """
  This module contains logic involving handling task related
  events received from nodes or generally task related operations.
  """
  require RexWeb.Events
  alias RexWeb.{Events, LoadBalancing, ProjectHandler}
  alias Rex.{Entity, Manager}

  @spec handle_fetch_task(String.t()) :: Task.t() | nil
  def handle_fetch_task(node_id) do
    case LoadBalancing.RoundRobin.get_next_task(node_id) do
      nil ->
        if is_finished?() do
          ProjectHandler.start_next_project()
          {:ok, Events.project_complete()}
        else
          {:ok, Events.no_tasks()}
        end
      task ->
        task
    end
  end

  def save_fragment(project_id, frame, file) do
    task = Entity.get_task_by_project(project_id, frame)
    path = Entity.save_fragment(task, file)
    Entity.update_task(task, %{path: path})
  end

  defp is_finished?() do
    with {:ok, %{project: %{id: project_id}}} <- Manager.get_state(),
         {:ok, status} <- ProjectHandler.handle_project_status(project_id) do
      %{
        all: all,
        complete: complete
      } = status
      Logger.info("Project status: #{inspect status}")
      all === complete
    end
  end
end
