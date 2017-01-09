{-
   This file was automatically generated by elm-graphql.
-}


module Blog exposing (users, Users)

import Json.Decode exposing (..)
import Json.Encode exposing (encode)
import Http
import GraphQL exposing (apply, maybeEncode)


endpointUrl : String
endpointUrl =
    "http://localhost:4000/api/"


type alias User =
    { name : Maybe String
    , email : Maybe String
    }


type alias Users =
    List User


users : Http.Request Users
users =
    let
        graphQLQuery =
            """query users { users { name, email } }"""
    in
        let
            graphQLParams =
                Json.Encode.object
                    []
        in
            GraphQL.query "POST" endpointUrl graphQLQuery "users" graphQLParams usersDecoder


usersDecoder : Decoder Users
usersDecoder =
    (at [ "data", "users" ] (list userDecoder))


userDecoder : Decoder User
userDecoder =
    map2 User
        (field "name" (maybe string))
        (field "email" (maybe string))
