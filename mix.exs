defmodule BankAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_api,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {BankAPI.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4.1"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:commanded, "~> 0.18"},
      {:eventstore, "~> 0.16.1", runtime: Mix.env() != :test},
      {:commanded_eventstore_adapter, "~> 0.5", runtime: Mix.env() != :test},
      {:commanded_ecto_projections, "~> 0.8"},
      {:skooma, "~> 0.2.0"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "event_store.setup": [
        "event_store.create",
        "event_store.init"
      ],
      "read_store.setup": [
        "ecto.create",
        "ecto.migrate"
      ],
      setup: [
        "event_store.setup",
        "read_store.setup"
      ],
      reset: [
        "event_store.drop",
        "event_store.setup",
        "ecto.drop",
        "read_store.setup"
      ],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
