require Logger

defmodule RexData.State do
  use GenServer

  alias RexData.Project.ProjectInfo
  alias RexData.Utils

  @name :state_manager
  defstruct project: %ProjectInfo{}

  @spec start_link(any) :: any
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: @name)
  end

  @spec start_new_project(ProjectInfo.t()) :: any
  def start_new_project(new_project),
    do: GenServer.cast(@name, {:start_project, new_project})

  @spec get_state() :: any
  def get_state(),
    do: GenServer.call(@name, {:get_state})

  @spec close_project() :: any
  def close_project(),
    do: GenServer.call(@name, {:close_project})

  @impl true
  def init(state) do
    # Implement disaster recovery here
    {:ok, state}
  end

  @impl true
  def handle_cast({:start_project, new_project}, state) do
    Logger.debug("Starting new project: state=#{inspect(state)}}")
    Utils.save_timestamp("project-#{new_project.id}.log", "START")
    {:noreply, %{state | project: new_project}}
  end

  @impl true
  def handle_call({:get_state}, _from, state),
    do: {:reply, {:ok, state}, state}

  @impl true
  def handle_call({:close_project}, _from, state) do
    Utils.save_timestamp("project-#{state.project.id}.log", "END")
    new_state = %{state | project: nil}
    {:reply, {:ok, new_state}, new_state}
  end
end
