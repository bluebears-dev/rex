require Logger

defmodule RexWeb.DelegateChannel do
  @moduledoc """
  Testing channel.
  """
  require Constants.Events
  alias Constants.Events
  
  use RexWeb, :channel
  alias RexWeb.{NodeHandler, ProjectHandler, TaskHandler}

  @spec join(String.t(), map, Phoenix.Socket.t()) :: {:ok, map, Phoenix.Socket.t()}
  def join("worker:rendering", payload, socket) do
    case NodeHandler.handle_join(payload) do
      {:ok, %{node_id: node_id} = node} ->
        node_socket = assign(socket, :node_id, node_id)

        send(self(), :after_join)
        {:ok, %{event: "JOIN", payload: node}, node_socket}

      error ->
        error
    end
  end

  def handle_in(Events.fetch_task(), _payload, socket) do
    result =
      Ecto.UUID.cast!(socket.assigns.node_id)
      |> TaskHandler.handle_fetch_task()

    case result do
      {:ok, event} when is_binary(event) ->
        {:reply, {:ok, %{event: event}}, socket}

      {:ok, task} ->
        {:reply, {:ok, %{event: Events.fetch_task(), payload: task}}, socket}
    end
  end

  def handle_info(:after_join, socket) do
    project = ProjectHandler.get_current_project()
    Logger.info("Project in progress: #{inspect(project)}")

    if project != nil do
      push(socket, Events.new_project(), %{project_id: project.id})
    end

    {:noreply, socket}
  end

  #  @spec terminate(tuple, Phoenix.Socket.t()) :: :ok
  #  def terminate(:shutdown, socket) do
  #    socket.assigns.node_id
  #    |> GroupHandler.handle_leave!()
  #  end
end
