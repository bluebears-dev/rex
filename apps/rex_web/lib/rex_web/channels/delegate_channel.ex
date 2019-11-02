require Logger

defmodule RexWeb.DelegateChannel do
  @moduledoc """
  Testing channel.
  """
  use RexWeb, :channel
  alias Rex.Nodes.Node
  alias RexWeb.GroupHandler

  @spec join(String.t(), Node.t(), Phoenix.Socket.t()) :: {:ok, map, Phoenix.Socket.t()}
  def join("group:" <> group_id, payload, socket) do
    worker_response = payload
                      |> Map.put_new("group_id", group_id)
                      |> GroupHandler.handle_join()

    IO.puts inspect worker_response
    case worker_response do
      {:ok, %{node_id: node_id}} = response ->
        Tuple.append(response, assign(socket, :node_id, node_id))
      error -> error
    end
  end

  @spec terminate(tuple, Phoenix.Socket.t()) :: :ok
  def terminate({:shutdown, :left}, socket) do
    socket.assigns.node_id
    |> GroupHandler.handle_leave!()
  end
end
