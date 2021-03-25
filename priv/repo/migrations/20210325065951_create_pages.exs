defmodule Microwiki.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :name, :string
      add :title, :string
      add :text, :text

      timestamps()
    end

    create unique_index(:pages, [:name])

  end
end
