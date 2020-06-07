require Logger

defmodule RexWeb.WorkerSocket do
  use Phoenix.Socket

  ## Channels
  channel "worker:*", RexWeb.WorkerChannel


  @spec connect(map, Phoenix.Socket.t(), map) :: {:ok, Phoenix.Socket.t()} | :error
  def connect(_params, socket, _connect_info),
    do: {:ok, socket}

  @spec id(Phoenix.Socket.t()) :: String.t() | nil
  def id(socket) do
    if Map.has_key?(socket.assigns, "node_id") do
      "worker:#{socket.assigns.node_id}"
    else
      nil
    end
  end
end
