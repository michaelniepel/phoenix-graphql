module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Blog exposing (users, Users)
import Http


-- MODEL


type alias Model =
    { users : Users
    , error : String
    , fetching : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "" False, Cmd.none )


type Msg
    = LoadUsers
    | FetchUsers (Result Http.Error Users)


fetchUsers : Cmd Msg
fetchUsers =
    Http.send FetchUsers <| users



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


mainView : Model -> Html Msg
mainView model =
    div []
        [ button [ Html.Events.onClick LoadUsers ] [ text "Load users" ]
        , p [] [ text model.error ]
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
