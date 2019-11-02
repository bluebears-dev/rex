defmodule Rex.NodesTest do
  use Rex.DataCase

  alias Rex.Nodes

  describe "node" do
    alias Rex.Nodes.Node

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def node_fixture(attrs \\ %{}) do
      {:ok, node} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Nodes.create_node()

      node
    end

    test "list_node/0 returns all node" do
      node = node_fixture()
      assert Nodes.list_node() == [node]
    end

    test "get_node!/1 returns the node with given id" do
      node = node_fixture()
      assert Nodes.get_node!(node.id) == node
    end

    test "create_node/1 with valid data creates a node" do
      assert {:ok, %Node{} = node} = Nodes.create_node(@valid_attrs)
    end

    test "create_node/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Nodes.create_node(@invalid_attrs)
    end

    test "update_node/2 with valid data updates the node" do
      node = node_fixture()
      assert {:ok, %Node{} = node} = Nodes.update_node(node, @update_attrs)
    end

    test "update_node/2 with invalid data returns error changeset" do
      node = node_fixture()
      assert {:error, %Ecto.Changeset{}} = Nodes.update_node(node, @invalid_attrs)
      assert node == Nodes.get_node!(node.id)
    end

    test "delete_node/1 deletes the node" do
      node = node_fixture()
      assert {:ok, %Node{}} = Nodes.delete_node(node)
      assert_raise Ecto.NoResultsError, fn -> Nodes.get_node!(node.id) end
    end

    test "change_node/1 returns a node changeset" do
      node = node_fixture()
      assert %Ecto.Changeset{} = Nodes.change_node(node)
    end
  end

  describe "machine" do
    alias Rex.Nodes.MachineInfo

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def machine_info_fixture(attrs \\ %{}) do
      {:ok, machine_info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Nodes.create_machine_info()

      machine_info
    end

    test "list_machine/0 returns all machine" do
      machine_info = machine_info_fixture()
      assert Nodes.list_machine() == [machine_info]
    end

    test "get_machine_info!/1 returns the machine_info with given id" do
      machine_info = machine_info_fixture()
      assert Nodes.get_machine_info!(machine_info.id) == machine_info
    end

    test "create_machine_info/1 with valid data creates a machine_info" do
      assert {:ok, %MachineInfo{} = machine_info} = Nodes.create_machine_info(@valid_attrs)
    end

    test "create_machine_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Nodes.create_machine_info(@invalid_attrs)
    end

    test "update_machine_info/2 with valid data updates the machine_info" do
      machine_info = machine_info_fixture()

      assert {:ok, %MachineInfo{} = machine_info} =
               Nodes.update_machine_info(machine_info, @update_attrs)
    end

    test "update_machine_info/2 with invalid data returns error changeset" do
      machine_info = machine_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Nodes.update_machine_info(machine_info, @invalid_attrs)
      assert machine_info == Nodes.get_machine_info!(machine_info.id)
    end

    test "delete_machine_info/1 deletes the machine_info" do
      machine_info = machine_info_fixture()
      assert {:ok, %MachineInfo{}} = Nodes.delete_machine_info(machine_info)
      assert_raise Ecto.NoResultsError, fn -> Nodes.get_machine_info!(machine_info.id) end
    end

    test "change_machine_info/1 returns a machine_info changeset" do
      machine_info = machine_info_fixture()
      assert %Ecto.Changeset{} = Nodes.change_machine_info(machine_info)
    end
  end

  describe "group" do
    alias Rex.Nodes.Group

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Nodes.create_group()

      group
    end

    test "list_group/0 returns all group" do
      group = group_fixture()
      assert Nodes.list_group() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Nodes.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Nodes.create_group(@valid_attrs)
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Nodes.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, %Group{} = group} = Nodes.update_group(group, @update_attrs)
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Nodes.update_group(group, @invalid_attrs)
      assert group == Nodes.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Nodes.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Nodes.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Nodes.change_group(group)
    end
  end
end
