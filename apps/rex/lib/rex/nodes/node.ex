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
  import Ecto.Changeset

  @primary_key {:node_id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :node_id}
  schema "node" do
    field :name, :string
    field :rendering_client, RenderingClientEnum
    field :performance, :integer, default: @not_yet_benchmarked
    field :connected, :boolean, virtual: true

    belongs_to :group, Rex.Nodes.Group, references: :name, source: :group_name

    timestamps()
  end

  @cast_params ~w(name rendering_client performance)
  @required_params ~w(name rendering_client)

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, @cast_params)
    |> validate_required(@required_params)
    |> assoc_constraint(:group)
  end
end
