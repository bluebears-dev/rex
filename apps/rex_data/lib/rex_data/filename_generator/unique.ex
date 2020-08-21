defmodule RexData.FilenameGenerator.Unique do
  @behaviour RexData.FilenameGenerator

  @impl RexData.FilenameGenerator
  def generate_filename(postfix),
    do: "#{Ecto.UUID.generate()}#{postfix}"
end
