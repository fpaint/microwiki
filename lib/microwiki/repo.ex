defmodule Microwiki.Repo do
  use Ecto.Repo,
    otp_app: :microwiki,
    adapter: Ecto.Adapters.Postgres
end
