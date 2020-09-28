defmodule RexData.Factory do
  alias RexData.Repo

  @typedoc """
  Alias for the all used factory atoms used in this module.
  """
  @type valid_factories :: :node | :project

  @default_node_id "b9bbbbc8-a8b7-11ea-bb37-0242ac130002"
  @default_node_name "TEST_NODE"
  @project_id 1

  @spec build(:node) :: %RexData.Worker.Node{}
  def build(:node),
    do: %RexData.Worker.Node{
      node_id: @default_node_id,
      name: @default_node_name
    }

  @spec build(:project) :: %RexData.Project.ProjectInfo{}
  def build(:project),
    do: %RexData.Project.ProjectInfo{
      id: @project_id,
      path: "path",
      type: :animation,
      width: 480,
      height: 360,
      starting_frame: 5,
      total_frames: 10
    }

  @spec build(valid_factories, []) :: any
  def build(factory, attrs) do
    factory
    |> build()
    |> struct(attrs)
  end

  @spec insert!(valid_factories, []) :: %{}
  def insert!(factory, attrs \\ []) do
    Repo.insert!(build(factory, attrs))
  end
end
