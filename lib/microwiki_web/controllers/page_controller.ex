defmodule MicrowikiWeb.PageController do
  use MicrowikiWeb, :controller
  alias Microwiki.Page
  alias Microwiki.Repo

  plug :clear_layout
  @main_page "_main"

  def index(conn, _params) do
    redirect(conn, to: Routes.page_path(conn, :show, @main_page))
  end

  def show(conn, %{"name" => name}) do 
    case get_page(name) do
      {:ok, page} ->
        render(conn, "show.html", token: get_csrf_token(), page: page)
      {:not_found, _} -> 
        conn
        |> put_status(404)
        |> render("new.html", name: name) 
    end
  end

  def show(conn, _) do
    show(conn, %{name: @main_page}) 
  end

  def edit(conn, params) do
    {_, page} = get_page(params["name"])
    render(conn, "edit.html", token: get_csrf_token(), page: page)    
  end

  def save(conn, params) do
    result = case get_page(params["name"]) do 
      {:ok, page} ->
        Page.changeset(page, params) |> Repo.update()
      {:not_found, page} -> 
        Page.changeset(page, params) |> Repo.insert()
    end
    case result do 
      {:ok, _} ->
        redirect(conn, to: Routes.page_path(conn, :show, params["name"]))
      {:error, _} -> 
        text(conn, inspect(result.errors))
    end
  end

  defp clear_layout(conn, _params) do 
    put_layout(conn, "clear.html")    
  end

  defp get_page(name) do
    case Repo.get_by(Page, name: name) do 
      nil -> {:not_found, %Page{}}
      page -> {:ok, page}
    end  
  end

end
