defmodule RexData.ProjectTest do
  use RexData.DataCase
  import RexData.Project
  alias RexData.Project.{ProjectInfo, Task}
  alias RexData.Factory

  doctest RexData.Project

  @project_id 1
  @not_existing_project_id -1

  test "get_project returns project" do
    Factory.insert!(:project)

    assert %ProjectInfo{id: @project_id} = get_project(@project_id)
  end

  test "get_project returns nil WHEN project with given id DOES NOT EXIST" do
    Factory.insert!(:project)

    assert get_project(@not_existing_project_id) == nil
  end
end
