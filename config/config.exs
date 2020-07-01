# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :rex_data,
  ecto_repos: [RexData.Repo]

config :rex_web,
  ecto_repos: [RexData.Repo],
  generators: [context_app: :rex_data]

# Configures the endpoint
config :rex_web, RexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WhgBH/ioogy0P0UFRAROIZjOD9aksrE+VoJxNSMZmHr03RRgqquhfU5QAgMNXwxR",
  render_errors: [view: RexWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RexWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "[$time][$level][$metadata] - $message\n",
  metadata: [:request_id, :function]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
