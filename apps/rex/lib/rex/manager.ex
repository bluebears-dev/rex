require Logger

defmodule Rex.Manager do
  use GenServer

  alias Rex.Entity

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: Manager)
  end

  def start_new_project(pid) do
    GenServer.cast(pid, {:start_project})
  end

  @impl true
  def init(state) do
    # Implement disaster recovery here
    {:ok, state}
  end

  @impl true
  def handle_call(:start_project, _from, %{project: current_project} = state) do
    Logger.debug("Called new project task: state=#{inspect state}}")
    if current_project != nil and current_project.state == :in_progress do
      {:reply, {:warn, "Project in progress"}, state}
    else
      case Entity.next_project() do
        nil ->
          {:reply, {:error, "No queued projects"}, state}
        project ->
          {:ok, new_project} = Entity.update_project(project, %{state: :in_progress})
          {:reply, {:ok, new_project}, %{state | project: new_project}}
      end
    end
  end
end