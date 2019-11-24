require Logger

defmodule RexWeb.ProjectHandler do
  alias Rex.Entity
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

  def handle_cancel(payload),
      do: Entity.cancel_project(payload)
end