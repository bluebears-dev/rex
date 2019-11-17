defmodule Rex.Entity.Frame do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frames" do
    field :complexity, :float
    field :number, :integer
    field :resultPath, :string, default: nil
    field :project, :id

    timestamps()
  end

  @doc false
  def changeset(frame, attrs) do
    frame
    |> cast(attrs, [:number, :complexity, :resultPath])
    |> validate_required([:number, :complexity, :resultPath])
  end
end
