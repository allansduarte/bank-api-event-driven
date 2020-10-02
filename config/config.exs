use Mix.Config

config :bank_api,
  namespace: BankAPI,
  ecto_repos: [BankAPI.Repo]

config :bank_api, BankAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5jrIpkJfAgtFb70SdYuboFqkUxkDUcda8IFd1XxW/pfMozACACYV2JU83D/LuwiE",
  render_errors: [view: BankAPIWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankAPI.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: BankAPI.Repo

import_config "#{Mix.env()}.exs"

if File.exists?("config/#{Mix.env()}.secret.exs") do
  import_config "#{Mix.env()}.secret.exs"
end
