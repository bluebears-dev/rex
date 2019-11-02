require Logger

defmodule RexWeb.GroupHandler do
  alias Rex.Nodes

  @spec handle_join(map) :: map
  def handle_join(%{"group_id" => group_id} = payload) do
    node_id = Ecto.UUID.generate()
    Logger.info("Generated UUID: #{node_id}")

    case try_create_node(payload, node_id) do
      {:ok, _} ->
        Logger.info("Node #{node_id} has joined the group:#{group_id}")
        {:ok, %{node_id: node_id}}
      {:error, %{reason: _}} = error ->
        error
      error ->
        {:error, %{reason: "fatal"}}
    end
  end

  defp try_create_node(payload, node_id) do
    try do
      payload
      |> Map.put_new("node_id", node_id)
      |> Nodes.create_node()
    rescue
      Ecto.ConstraintError -> {:error, %{reason: "constraint"}}
    end
  end

  @spec handle_leave!(String.t()) :: map
  def handle_leave!(node_id) do
    if Nodes.node_exists?(node_id) do
      Nodes.get_node!(node_id)
      |> Nodes.delete_node()
      Logger.info("node:#{node_id} has been cleaned up")
    end
    Logger.info("node:#{node_id}")
    :ok
  end
end
