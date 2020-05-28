defmodule RexData.Node.NodeInfo do
  @moduledoc """
  Scheme for node entity.
  It consists of several fields:

    node_id:          UUID for worker node
    name:             Human readable name of the worker

  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:node_id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :node_id}
  schema "nodes" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:node_id, :name])
    |> validate_required([:node_id, :name])
  end
end
