defmodule Rex.RenderGroupsTest do
  use Rex.DataCase

  alias Rex.RenderGroups

  describe "group" do
    alias Rex.RenderGroups.Group

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RenderGroups.create_group()

      group
    end

    test "list_group/0 returns all group" do
      group = group_fixture()
      assert RenderGroups.list_group() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert RenderGroups.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = RenderGroups.create_group(@valid_attrs)
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RenderGroups.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, %Group{} = group} = RenderGroups.update_group(group, @update_attrs)
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = RenderGroups.update_group(group, @invalid_attrs)
      assert group == RenderGroups.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = RenderGroups.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> RenderGroups.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = RenderGroups.change_group(group)
    end
  end
end
