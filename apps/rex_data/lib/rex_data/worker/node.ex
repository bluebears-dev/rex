defmodule RexData.Worker.Node do
  @moduledoc """
  Scheme for node entity.
  It consists of several fields:

    node_id:          UUID for worker node
    name:             Human readable name of the worker

  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:node_id, :name]

  @primary_key {:node_id, Ecto.UUID, []}
  @derive {Phoenix.Param, key: :node_id}

  schema "nodes" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:node_id, name: :nodes_pkey)
  end
end
