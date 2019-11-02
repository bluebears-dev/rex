require Logger

defmodule RexWeb.UserSocket do
  use Phoenix.Socket
  alias Rex.Nodes.Node

  ## Channels
  channel "group:*", RexWeb.DelegateChannel

  @spec connect(map, Phoenix.Socket.t(), map) :: {:ok, Phoenix.Socket.t()} | :error
  def connect(_params, socket, _connect_info),
      do: {:ok, socket}

  # TODO: implement returning ID when node_id is set
  @spec id(Phoenix.Socket.t()) :: String.t()
  def id(socket), do: nil
end
