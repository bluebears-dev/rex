defmodule RexData.Factory do
  alias RexData.Repo

  @typedoc """
  Alias for the all used factory atoms used in this module.
  """
  @type valid_factories :: :node

  @default_node_id "b9bbbbc8-a8b7-11ea-bb37-0242ac130002"
  @default_node_name "TEST_NODE"

  @spec build(:node) :: RexData.Worker.Node.t()
  def build(:node),
    do: %RexData.Worker.Node{
      node_id: @default_node_id,
      name: @default_node_name
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
