module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import GraphQL.Blog exposing (usersRequest, Users, User)
import Http


-- MODEL


type alias Model =
    { users : Users
    , error : String
    , fetching : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "" False, fetchUsers )


type Msg
    = LoadUsers
    | FetchUsers (Result Http.Error Users)


fetchUsers : Cmd Msg
fetchUsers =
    Http.send FetchUsers <| usersRequest



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadUsers ->
            ( { model | fetching = True }, fetchUsers )

        FetchUsers (Ok users) ->
            ( { model | error = "", users = users, fetching = False }, Cmd.none )

        FetchUsers (Err err) ->
            ( { model | error = (toString err), users = [], fetching = False }, Cmd.none )



-- VIEW


usersSection : Model -> Html Msg
usersSection model =
    let
        listHtml =
            if (model.fetching == True) then
                p [] [ text "Fetching..." ]
            else
                ul [] (List.map (\user -> userDetail user) model.users)
    in
        div [ class "users" ]
            [ h3 [ Html.Events.onClick LoadUsers ] [ text "Users" ]
            , listHtml
            ]


userDetail : User -> Html Msg
userDetail user =
    li [] [ text user.name ]


mainView : Model -> Html Msg
mainView model =
    div []
        [ p [] [ text model.error ]
        , usersSection model
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- PROGRAM


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = mainView
        , update = update
        , subscriptions = subscriptions
        }
