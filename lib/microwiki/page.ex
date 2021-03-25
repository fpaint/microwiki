defmodule Microwiki.Page do
  use Ecto.Schema
  import Ecto.Changeset
  import Earmark

  schema "pages" do
    field :name, :string
    field :text, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:name, :title, :text])
    |> validate_required([:name, :title, :text])
  end

  def html(page) do 
    {:ok, html, _} = Earmark.as_html(page.text)
    html
  end
end
