defmodule RexWeb.TaskHandler do
  @moduledoc """
  This module contains logic involving handling task related
  events received from nodes or generally task related operations.
  """
  alias RexWeb.LoadBalancing

  @spec handle_fetch_task(String.t()) :: Task.t()
  def handle_fetch_task(node_id) do
    LoadBalancing.RoundRobin.get_next_task(node_id)
  end

  def save_fragment() do

  end
end
