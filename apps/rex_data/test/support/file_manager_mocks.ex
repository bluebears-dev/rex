defmodule RexData.FileManager.CustomFile do
  def cp(path_a, path_b, callback) do
    send(self(), {:cp, path_a, path_b, callback.(path_a, path_b)})
    :ok
  end

  def mkdir_p(_path) do
    send(self(), :mkdir)
    :ok
  end
end

defmodule RexData.FileManager.BrokenMkdirFile do
  def cp(_path_a, _path_b, _callback),
    do: :ok

  def mkdir_p(_path),
    do: {:error, :always_fails}
end

defmodule RexData.FileManager.BrokenCpFile do
  def cp(_path_a, _path_b, _callback),
    do: {:error, :always_fails}

  def mkdir_p(_path) do
    send(self(), :mkdir)
    :ok
  end
end
