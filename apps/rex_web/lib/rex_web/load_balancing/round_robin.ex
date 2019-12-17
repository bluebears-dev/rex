require Logger

defmodule RexWeb.LoadBalancing.RoundRobin do
  alias Rex.{Entity, Manager}
  alias RexWeb.LoadBalancing
  @behaviour LoadBalancing

  @impl LoadBalancing
  def get_next_task(node_id) do
    Logger.debug(node_id)

    with {:ok, %{project: %{id: project_id}}} <- Manager.get_state(),
         task when not is_nil(task) <- Entity.first_free_task(project_id) do
      Entity.update_task(task, %{node: node_id})
    end
  end
end
