module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Blog exposing (users, Users)
import Http


-- MODEL


type alias Model =
    { counter : Int
    , users : Maybe Users
    , error : String
    , fetching : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model 0 Nothing "" False, Cmd.none )


type Msg
    = Inc
    | Dec
    | LoadUsers
    | FetchUsers (Result Http.Error Users)


fetchUsers : Cmd Msg
fetchUsers =
    Http.send FetchUsers <| users



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Inc ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Dec ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        LoadUsers ->
            ( { model | fetching = True }, fetchUsers )

        FetchUsers (Ok users) ->
            ( { model | users = Just users, fetching = False }, Cmd.none )

        FetchUsers (Err err) ->
            ( { model | error = (toString err), fetching = False }, Cmd.none )



-- VIEW


mainView : Model -> Html Msg
mainView model =
    div []
        [ button [ onClick Inc ] [ text "+" ]
        , button [ onClick Dec ] [ text "-" ]
        , button [ Html.Events.onClick LoadUsers ] [ text "Load users" ]
        , p [] [ text (toString model.counter) ]
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
