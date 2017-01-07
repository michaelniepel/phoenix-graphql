module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    { counter : Int
    }


init : Model
init =
    Model 0


type Msg
    = Inc
    | Dec



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        Inc ->
            { model | counter = model.counter + 1 }

        Dec ->
            { model | counter = model.counter - 1 }



-- VIEW


mainView : Model -> Html Msg
mainView model =
    div []
        [ button [ onClick Inc ] [ text "+" ]
        , button [ onClick Dec ] [ text "-" ]
        , p [] [ text (toString model.counter) ]
        ]



-- PROGRAM


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = mainView
        , update = update
        }
