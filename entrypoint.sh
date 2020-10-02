DB_USER=${DATABASE_USER:-postgres}
DB_HOST=db

case "$MIX_ENV" in
  dev)
    DB_HOST=${DATABASE_HOST_DEV}
  ;;
  prod)
    DB_HOST=${DATABASE_HOST}
  ;;
  test)
    DB_HOST=${DATABASE_HOST_TEST}
  ;;
esac

# wait until Postgres is ready
while ! pg_isready -q -h "$DB_HOST" -p 5432 -U "$DB_USER"
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

case "$MIX_ENV" in
  dev)
    mix setup
    mix phx.server
  ;;
  prod)
    bin="/app/bin/bank_api"
    eval "$bin eval \"BankApi.Release.migrate\""
    # start the elixir application
    exec "$bin" "start"
  ;;
  test)
    mix setup
    mix test --cover --color
    mix credo --strict
  ;;
esac