require Logger

defmodule RexWeb.DelegateChannel do
  @moduledoc """
  Testing channel.
  """
  use RexWeb, :channel
  alias RexWeb.NodeHandler

  @spec join(String.t(), map, Phoenix.Socket.t()) :: {:ok, map, Phoenix.Socket.t()}
  def join("worker:rendering", payload, socket) do
    case NodeHandler.handle_join(payload) do
      {:ok, %{node_id: node_id}} = response ->
        Tuple.append(response, assign(socket, :node_id, node_id))
      error -> error
    end
  end

  #  @spec terminate(tuple, Phoenix.Socket.t()) :: :ok
  #  def terminate(:shutdown, socket) do
  #    socket.assigns.node_id
  #    |> GroupHandler.handle_leave!()
  #  end
end
