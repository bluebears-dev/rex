defmodule RexData.FilenameGenerator do
  @callback generate_filename(String.t()) :: String.t()

  @spec get() :: RexData.FilenameGenerator
  def get() do
    Application.get_env(:rex_data, RexData.FilenameGenerator)
    |> Keyword.get(:generator)
  end
end
