defmodule RexData.Worker.NodeTest do
  use RexData.DataCase
  import RexData.Worker.Node
  alias RexData.Factory
  alias RexData.Worker.Node
  alias RexData.Repo

  @node_id "b9bbbbc8-a8b7-11ea-bb37-0242ac130002"

  test "changeset filters out irrelevant fields" do
    assert %{data: node} = changeset(%Node{}, %{node_id: "NODE_ID", name: "TEST_NODE", some_field: 0})
    assert Map.has_key?(node, :node_id)
    assert Map.has_key?(node, :name)
    assert Map.has_key?(node, :inserted_at)
    assert Map.has_key?(node, :updated_at)
    refute Map.has_key?(node, :some_field)
  end

  test "changeset validates required fields" do
    assert %{errors: errors, valid?: false} = changeset(%Node{}, %{})
    assert [node_id: {"can't be blank", _}, name: {"can't be blank", _}] = errors
  end

  test "changeset returns error WHEN node_id is not unique" do
    Factory.insert!(:node)

    node_changeset = changeset(%Node{}, %{node_id: @node_id, name: "NEW_NODE"})
    assert {:error, %{errors: errors}} = Repo.insert(node_changeset)
    assert [node_id: {"has already been taken", _}] = errors
  end
end
