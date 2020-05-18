require Logger

defmodule RexWeb.NodeHandler do
  @moduledoc """
  Module containing logic for node specific operations.

  *handle_join*
  This method is used to handle node joining the rendering.
  """
  alias Rex.{Entity, Manager, Utils}

  @spec handle_join(Node.t()) :: {:ok, map} | {:error, map}
  def handle_join(%{"node_id" => node_id}) when node_id != "" do
    Logger.info("Trying to join with id: #{node_id}")

    case Entity.get_node(node_id) do
      nil ->
        {:error,
         %{
           reason: "not_found",
           details: "Node ID does not exist"
         }}
      _ ->
        {:ok, %{node_id: node_id}}
    end
  end

  def handle_join(payload) do
    Logger.info("Node info: #{inspect(payload)}")
    node_id = Ecto.UUID.generate()
    Logger.info("Generated UUID: #{node_id}")

    Map.put(payload, "node_id", node_id)
    |> Entity.create_node()
    |> case do
      {:ok, _} ->
        Logger.info("Node #{node_id} has joined")
        {:ok, %{node_id: node_id}}

      {:error, %{errors: errors}} ->
        {:error,
         %{
           reason: "validation",
           details: Utils.format_validation_errors(errors)
         }}
    end
  end

  @spec handle_leave!(String.t()) :: map
  def handle_leave!(_node_id) do
    #    if Nodes.node_exists?(node_id) do
    #      Nodes.get_node(node_id)
    #      |> Nodes.delete_node()
    #      Logger.info("node:#{node_id} has been cleaned up")
    #    end
    #    Logger.info("node:#{node_id}")
    #    :ok
  end
end
