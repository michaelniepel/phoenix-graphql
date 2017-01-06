defmodule Graphql.Schema.Types do
  use Absinthe.Schema.Notation # DSL for graphQL types
  use Absinthe.Ecto, repo: Graphql.Repo # ecto helpers

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :posts, list_of(:post), resolve: assoc(:posts)
  end

  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
    field :user, :user, resolve: assoc(:user)
  end
end