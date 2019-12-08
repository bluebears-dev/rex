require Logger

defmodule RexWeb.ProjectHandler do
  alias Rex.{Entity, Manager}
  alias Rex.Entity.Project
  alias RexWeb.Endpoint

  def handle_new(payload) do
    with {:ok, _project} <- Entity.create_project(payload),
         {:ok, started_project} <- Manager.start_new_project() do
      response = %{project_id: started_project.id}
      Logger.debug("Broadcasting info about new project")

      Endpoint.broadcast!(
        "worker:rendering",
        "new:project",
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

      %Project{path: path} ->
        {:ok, path}
    end
  end

  @spec get_current_project() :: Project.t()
  def get_current_project() do
    with {:ok, response} <- Manager.get_state(),
         %{project: project} <- response,
         %{state: :in_progress} <- project do
      project
    else
      anything ->
        Logger.debug("#{inspect anything}")
        nil
    end
  end
end
