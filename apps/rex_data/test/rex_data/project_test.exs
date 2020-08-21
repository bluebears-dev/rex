defmodule RexData.ProjectTest do
  use RexData.DataCase
  import RexData.Project
  alias RexData.{Factory, Repo}
  alias RexData.FileManager.{BrokenCpFile, BrokenMkdirFile, CustomFile}
  alias RexData.Project.{ProjectInfo}

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

  test "insert_new_project correctly saves project" do
    {:ok, project_info} =
      Factory.build(:project)
      |> Map.from_struct()
      |> insert_new_project("some_path", CustomFile)

    assert %ProjectInfo{
             height: 360,
             width: 480,
             path: "stub_filename"
           } = project_info

    assert Repo.exists?(ProjectInfo)
  end

  test "insert_new_project fails if it cannot copy the file" do
    {:error, error} =
      Factory.build(:project)
      |> Map.from_struct()
      |> insert_new_project("some_path", BrokenMkdirFile)

    assert :always_fails = error
  end
end
