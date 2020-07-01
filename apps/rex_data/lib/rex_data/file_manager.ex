require Logger

defmodule RexData.FileManager do
  @moduledoc """
  This module provides functions for file manipulation used by the `RexData`
  """

  defp get_path do
    Application.get_env(:rex_data, RexData.FileManager)
    |> Keyword.get(:path)
  end

  @doc """
  Copies file from given path to predefined path with new filename.
  It also creates specified path when it does not exist. Can overwrite files.

  Fails in the same scenarios as `File.cp/3` with custom callback and `File.mkdir_p/1`.

  Third argument serves as a dependency injection for testing purposes.

  ## Configuration

  The resulting path is different on each environment.
  See configuration files or `RexData.FileManager.get_path/1` for more info
  """
  @spec copy_file(Path.t(), Path.t()) :: :ok | {:error, atom}
  def copy_file(existing_path, new_filename, file_dependency \\ File) do
    do_copy_file(existing_path, Path.join(get_path(), new_filename), file_dependency)
  end

  @spec do_copy_file(Path.t(), Path.t(), any) :: :ok | {:error, atom}
  defp do_copy_file(existing_path, new_path, file_dependency) do
    Logger.info("Copying file '#{existing_path}' to '#{new_path}'")

    with :ok <- file_dependency.mkdir_p(Path.dirname(new_path)) do
      do_not_overwrite = fn _, _ -> false end
      file_dependency.cp(existing_path, new_path, do_not_overwrite)
    end
  end
end
