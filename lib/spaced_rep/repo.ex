defmodule SpacedRep.Repo do
  use Ecto.Repo,
    otp_app: :spaced_rep,
    adapter: Ecto.Adapters.Postgres
end
