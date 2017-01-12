{-
   This file was automatically generated by elm-graphql.
-}


module GraphQL.Blog exposing (usersRequest, loginRequest, Users, User, Token)

import Json.Decode exposing (..)
import Json.Encode exposing (encode)
import Http
import GraphQL exposing (apply, maybeEncode)


endpointUrl : String
endpointUrl =
    "http://localhost:4000/api/"



-- TYPES


type alias User =
    { name : String
    , email : String
    }


type alias Users =
    List User


type alias Token =
    String



-- REQUESTS


usersRequest : Http.Request Users
usersRequest =
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


loginRequest : Http.Request Token
loginRequest =
    let
        graphQLQuery =
            """mutation Login { login(email:"michael.niepel@gmail.com", password:"123456"){token}}"""
    in
        let
            graphQLParams =
                Json.Encode.object
                    []
        in
            GraphQL.mutation endpointUrl graphQLQuery "Login" graphQLParams tokenDecoder



-- DECODERS


usersDecoder : Decoder Users
usersDecoder =
    (at [ "data", "users" ] (list userDecoder))


userDecoder : Decoder User
userDecoder =
    map2 User
        (field "name" string)
        (field "email" string)


tokenDecoder : Decoder Token
tokenDecoder =
    (at [ "data", "login", "token" ] string)
