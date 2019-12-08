require Logger

defmodule Rex.Manager do
  use GenServer

  alias Rex.{Entity, Manager}
  alias Rex.Entity.Project

  @name :manager
  defstruct project: %Project{}

  @spec start_link(Manager.t()) :: any
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: @name)
  end

  @spec start_new_project(Project.t()) :: any
  def start_new_project(new_project),
    do: GenServer.cast(@name, {:start_project, new_project})

  @spec get_state() :: any
  def get_state(),
    do: GenServer.call(@name, {:get_state})

  @impl true
  def init(state) do
    # Implement disaster recovery here
    {:ok, state}
  end

  @impl true
  def handle_cast({:start_project, new_project}, state) do
    Logger.debug("Starting new project: state=#{inspect state}}")
    {:noreply, %{state | project: new_project}}
  end

  @impl true
  def handle_call({:get_state}, _from, state),
    do: {:reply, {:ok, state}, state}
end
