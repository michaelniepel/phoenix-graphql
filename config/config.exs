# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :graphql,
  ecto_repos: [Graphql.Repo]

# Configures the endpoint
config :graphql, Graphql.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3e5YJ5LjYKStdv49NiEmg7+jxc7W7zP6IdpG1p8/Lcpj+vk9lrN+tcM+JvvzMFsV",
  render_errors: [view: Graphql.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Graphql.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Graphql",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: "3e5YJ5LjYKStdv49NiEmg7+jxc7W7zP6IdpG1p8/Lcpj+vk9lrN+tcM+JvvzMFsV",
  serializer: Graphql.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
