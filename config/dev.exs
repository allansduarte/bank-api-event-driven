use Mix.Config

config :bank_api, BankAPIWeb.Endpoint,
  http: [port: 4001],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :bank_api, BankAPI.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_api_dev",
  hostname: System.get_env("DATABASE_HOST_DEV") || "localhost",
  pool_size: 10

config :eventstore,
  column_data_type: "jsonb"

config :eventstore, EventStore.Storage,
  serializer: EventStore.JsonbSerializer,
  types: EventStore.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "bank_api_eventstore_dev",
  hostname: "localhost",
  pool_size: 10,
  pool_overflow: 5
