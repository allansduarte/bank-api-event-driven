use Mix.Config

config :bank_api, BankAPIWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :bank_api, BankAPI.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_api_test",
  hostname: "localhost"

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory

config :commanded, Commanded.EventStore.Adapters.InMemory,
  serializer: Commanded.Serialization.JsonSerializer

config :ex_unit, capture_log: true
