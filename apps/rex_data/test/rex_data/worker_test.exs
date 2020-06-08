defmodule RexData.WorkerTest do
  use RexData.DataCase
  import RexData.Worker
  alias RexData.Worker.Node
  alias RexData.Factory

  doctest RexData.Worker

  @node_id "b9bbbbc8-a8b7-11ea-bb37-0242ac130002"
  @not_existing_node_id "00000000-0000-0000-0000-000000000000"
  @node_name "TEST_NODE"

  test "get_node? returns node WHEN node with specified id EXIST" do
    Factory.insert!(:node)

    assert %Node{name: @node_name, node_id: @node_id} = get_node?(@node_id)
  end

  test "get_node? returns nil WHEN node with specified id DOES NOT EXIST" do
    assert nil == get_node?(@not_existing_node_id)
  end

  test "create_node returns :ok tuple WHEN payload is valid" do
    assert {:ok, node} = create_node(%{name: @node_name})
  end

  test "create_node returns :ok tuple with generated id WHEN user provides custom one" do
    assert {:ok, node} = create_node(%{name: @node_name, node_id: @not_existing_node_id})
    assert node.node_id != @not_existing_node_id
  end

  test "create_node returns :error tuple WHEN payload is invalid" do
    assert {:error, changeset} = create_node(%{})
    assert {:error, changeset} = create_node(%{some_field: 0})
    assert {:error, changeset} = create_node(%{node_id: "abcd", field: 0})
  end
end
