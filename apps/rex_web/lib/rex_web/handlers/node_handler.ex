require Logger

defmodule RexWeb.NodeHandler do
  alias Rex.Entity

  @spec handle_join(Node.t()) :: {:ok, map} | {:error, map}
  def handle_join(payload) do
    Logger.info("Node info: #{inspect payload}")
    node_id = Ecto.UUID.generate()
    Logger.info("Generated UUID: #{node_id}")

    # add project_id as a return if project is rendering
    Map.put(payload, "node_id", node_id)
    |> Entity.create_node()
    |> case do
      {:ok, _} ->
        Logger.info("Node #{node_id} has joined")
        {:ok, %{node_id: node_id}}
      {:error, %{errors: errors}} ->
        {:error, %{
          reason: "validation",
          details: Entity.format_validation_errors(errors)
        }}
    end
  end


  @spec handle_leave!(String.t()) :: map
  def handle_leave!(node_id) do
    #    if Nodes.node_exists?(node_id) do
    #      Nodes.get_node(node_id)
    #      |> Nodes.delete_node()
    #      Logger.info("node:#{node_id} has been cleaned up")
    #    end
    #    Logger.info("node:#{node_id}")
    #    :ok
  end
end
