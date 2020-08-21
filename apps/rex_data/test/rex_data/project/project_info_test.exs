defmodule RexData.Project.ProjectInfoTest do
  use RexData.DataCase
  import RexData.Project.ProjectInfo
  alias RexData.Factory
  alias RexData.Project.ProjectInfo
  alias RexData.Repo

  test "changeset filters out irrelevant fields" do
    assert %{changes: project_info} =
             changeset(%ProjectInfo{}, %{
               path: "a",
               type: :animation,
               width: 1,
               height: 1,
               starting_frame: 0,
               total_frames: 5,
               result: "abc",
               state: :queued,
               some_field: 0
             })

    assert Map.has_key?(project_info, :path)
    assert Map.has_key?(project_info, :type)
    assert Map.has_key?(project_info, :width)
    assert Map.has_key?(project_info, :height)
    assert Map.has_key?(project_info, :starting_frame)
    assert Map.has_key?(project_info, :total_frames)
    assert Map.has_key?(project_info, :result)
    refute Map.has_key?(project_info, :state)
    refute Map.has_key?(project_info, :some_field)
  end

  test "changeset validates required fields" do
    assert %{errors: errors, valid?: false} = changeset(%ProjectInfo{}, %{})

    assert [
             path: {"can't be blank", _},
             type: {"can't be blank", _},
             width: {"can't be blank", _},
             height: {"can't be blank", _},
             starting_frame: {"can't be blank", _},
             total_frames: {"can't be blank", _}
           ] = errors
  end

  test "new filters out irrelevant fields" do
    assert %{changes: project_info} = new(%{
      path: "a",
      type: :animation,
      width: 1,
      height: 1,
      starting_frame: 0,
      total_frames: 5,
      result: "abc",
      state: :queued,
      some_field: 0
    })

    assert Map.has_key?(project_info, :path)
    assert Map.has_key?(project_info, :type)
    assert Map.has_key?(project_info, :width)
    assert Map.has_key?(project_info, :height)
    assert Map.has_key?(project_info, :starting_frame)
    assert Map.has_key?(project_info, :total_frames)
    refute Map.has_key?(project_info, :result)
    refute Map.has_key?(project_info, :state)
    refute Map.has_key?(project_info, :some_field)
  end

  test "new validates required fields" do
    assert %{errors: errors, valid?: false} = new(%{})

    assert [
             path: {"can't be blank", _},
             type: {"can't be blank", _},
             width: {"can't be blank", _},
             height: {"can't be blank", _},
             starting_frame: {"can't be blank", _},
             total_frames: {"can't be blank", _}
           ] = errors
  end
end
