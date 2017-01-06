defmodule Graphql.PostResolver do
  alias Graphql.Repo
  alias Graphql.Post

  def all(_args, _info) do
    {:ok, Repo.all(Post)}
  end

  def create(args, _info) do
    %Post{}
    |> Post.changeset(args)
    |> Repo.insert
  end
end