require Logger

defmodule Rex.Manager do
  use GenServer

  alias Rex.Entity

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: :manager)
  end

  def start_new_project(),
    do: GenServer.call(:manager, {:start_project})

  def get_state(),
    do: GenServer.call(:manager, {:get_state})

  @impl true
  def init(state) do
    # Implement disaster recovery here
    {:ok, state}
  end

  @impl true
  def handle_call({:start_project}, _from, %{project: %{state: :in_progress}} = state) do
    Logger.debug("Called new project task: state=#{inspect(state)}}")
    {:reply, {:warn, "Project in progress"}, state}
  end

  @impl true
  def handle_call({:start_project}, _from, state) do
    Logger.debug("Called new project task: state=#{inspect(state)}}")
    case Entity.next_project() do
      nil ->
        {:reply, {:error, "No queued projects"}, state}

      project ->
        {:ok, new_project} = response = Entity.update_project(project, %{state: :in_progress})
        {:reply, response, %{state | project: new_project}}
    end
  end

  @impl true
  def handle_call({:get_state}, _from, state),
    do: {:reply, {:ok, state}, state}
end
