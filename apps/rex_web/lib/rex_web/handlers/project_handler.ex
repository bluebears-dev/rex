require Logger

defmodule RexWeb.ProjectHandler do
  alias Rex.Entity
  alias Rex.Entity.Project
  alias RexWeb.Endpoint

  def handle_new(payload) do
    with {:ok, project} <- Entity.create_project(payload),
         {:ok, started_project} <- GenServer.call(Manager, :start_project)
    do
      response = %{id: started_project.id}
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
end