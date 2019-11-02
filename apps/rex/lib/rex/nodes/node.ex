import EctoEnum
defenum(RenderingClientEnum, blender: 0)

defmodule Rex.Nodes.Node do
  @not_yet_benchmarked -1
  @moduledoc """
  Scheme for node entity.
  It consists of several fields:

    node_id:          UUID for worker node
    name:             Human readable name of the worker
    rendering_client: Client software used for rendering (currently only Blender is supported)
    performance:      Time spent in milliseconds when benchmarking
    group:            Indicates joined rendering group
    connected:        Is node still connected

  """
  use Ecto.Schema
  alias Rex.Nodes.Group
  import Ecto.Changeset

  @primary_key {:node_id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :node_id}
  schema "node" do
    field :name, :string
    field :rendering_client, RenderingClientEnum
    field :performance, :integer, default: @not_yet_benchmarked
    field :connected, :boolean, virtual: true

    belongs_to :group, Group, references: :name, source: :group, type: :string

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:node_id, :name, :rendering_client, :performance])
    |> assoc_constraint(:group)
    |> validate_required([:node_id, :name, :rendering_client])
  end
end
