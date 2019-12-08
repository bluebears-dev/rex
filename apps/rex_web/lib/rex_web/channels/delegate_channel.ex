require Logger

defmodule RexWeb.DelegateChannel do
  @moduledoc """
  Testing channel.
  """
  use RexWeb, :channel
  alias RexWeb.{NodeHandler, ProjectHandler}

  @spec join(String.t(), map, Phoenix.Socket.t()) :: {:ok, map, Phoenix.Socket.t()}
  def join("worker:rendering", payload, socket) do
    case NodeHandler.handle_join(payload) do
      {:ok, %{node_id: node_id}} = response ->
        node_socket = assign(socket, :node_id, node_id)


        send(self(), :after_join)
        Tuple.append(response, node_socket)
      error -> error
    end
  end

  def handle_info(:after_join, socket) do
    project = ProjectHandler.get_current_project()
    Logger.info("Project in progress: #{inspect project}")
    if project != nil do
      push(socket, "new:project", %{project_id: project.id})
    end
    {:noreply, socket}
  end

  #  @spec terminate(tuple, Phoenix.Socket.t()) :: :ok
  #  def terminate(:shutdown, socket) do
  #    socket.assigns.node_id
  #    |> GroupHandler.handle_leave!()
  #  end
end
