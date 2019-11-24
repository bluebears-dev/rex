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
end