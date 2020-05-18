defprotocol RexWeb.LoadBalancing do
  @callback get_next_task(String.t()) :: Task.t()
end
