defmodule Rex.Entity.Task do
  use Ecto.Schema
  alias Rex.Entity.{Node, Project}
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:frame, :project]
  }
  schema "tasks" do
    field :frame, :integer
    field :path, :string
    field :project, :id
    field :node, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:frame, :path, :project, :node])
    |> validate_required([:frame, :project])
  end
end
