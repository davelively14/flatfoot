use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flatfoot, Flatfoot.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Reduce number of Bcrypt rounds, speeds up testing
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :flatfoot, Flatfoot.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "flatfoot_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

if File.exists?("config/dev.secret.exs") do
  import_config "dev.secret.exs"
else
  config :flatfoot, :twitter, token: System.get_env("TWITTER_TOKEN")
end
