defmodule Graphql.Schema do
  use Absinthe.Schema
  import_types Graphql.Schema.Types

  query do
    field :posts, list_of(:post) do
      resolve &Graphql.PostResolver.all/2
    end

    field :users, list_of(:user) do
      resolve &Graphql.UserResolver.all/2
    end

    field :user, type: :user do
      arg :id, non_null(:id)

      resolve &Graphql.UserResolver.find/2
    end
  end

  mutation do
    field :create_post, type: :post do
      arg :title, non_null(:string)
      arg :body, non_null(:string)
      arg :user_id, non_null(:integer)

      resolve &Graphql.PostResolver.create/2
    end
  end
end