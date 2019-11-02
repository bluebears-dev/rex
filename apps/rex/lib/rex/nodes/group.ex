defmodule Rex.Nodes.Group do
  @moduledoc """
  Scheme for group entity.
  Used for grouping nodes into rendering jobs.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :name}
  @derive {Jason.Encoder, only: [:name]}
  @primary_key {:name, :string, []}
  schema "group" do
    has_many :nodes, Rex.Nodes.Node, foreign_key: :node_id
    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([])
    |> unique_constraint(:name, name: :group_pkey)
  end
end
