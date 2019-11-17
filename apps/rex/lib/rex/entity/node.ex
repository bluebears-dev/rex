defmodule Rex.Entity.Node do
  @not_yet_benchmarked -1
  @moduledoc """
  Scheme for node entity.
  It consists of several fields:

    node_id:          UUID for worker node
    name:             Human readable name of the worker
    performance:      Time spent in milliseconds when benchmarking

  """
  use Ecto.Schema
  alias Rex.Nodes.Group
  import Ecto.Changeset

  @primary_key {:node_id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :node_id}
  schema "nodes" do
    field :name, :string
    field :performance, :integer, default: @not_yet_benchmarked

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:node_id, :name, :performance])
    |> validate_required([:node_id, :name])
  end
end
