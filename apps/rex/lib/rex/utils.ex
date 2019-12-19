defmodule Rex.Utils do
  def format_validation_errors(error_keyword_list) do
    Enum.into(
      error_keyword_list,
      [],
      fn {key, tuple} ->
        to_string(key) <> " " <> elem(tuple, 0)
      end
    )
  end

  defp get_current_timestamp(),
    do: :os.system_time(:seconds)

  def save_timestamp(path, message),
    do: File.write!(path, "#{message}-#{get_current_timestamp()}", [:append])
end
