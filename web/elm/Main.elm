module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class, type_, value, placeholder)
import GraphQL.Blog exposing (usersRequest, loginRequest, Users, User, Token)
import Http


-- MODEL


type alias Model =
    { users : Users
    , error : String
    , fetching : Bool
    , userToken : Maybe Token
    , email : String
    , password : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model [] "" False Nothing "" "", fetchUsers )


type Msg
    = LoadUsers
    | FetchUsers (Result Http.Error Users)
    | Login
    | LoginResult (Result Http.Error Token)
    | InputEmail String
    | InputPassword String


fetchUsers : Cmd Msg
fetchUsers =
    Http.send FetchUsers <| usersRequest


login : Model -> Cmd Msg
login model =
    Http.send LoginResult <| loginRequest model.email model.password



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

        Login ->
            ( { model | userToken = Nothing }, (login model) )

        LoginResult (Ok token) ->
            ( { model | userToken = Just token, error = "" }, Cmd.none )

        LoginResult (Err err) ->
            ( { model | userToken = Nothing, error = (toString err) }, Cmd.none )

        InputEmail email ->
            ( { model | email = email }, Cmd.none )

        InputPassword pwd ->
            ( { model | password = pwd }, Cmd.none )



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


loginForm : Model -> Html Msg
loginForm model =
    div []
        [ input [ type_ "text", value model.email, placeholder "john@doe.com", onInput InputEmail ] []
        , input [ type_ "password", value model.password, onInput InputPassword ] []
        ]


loginButton : Html Msg
loginButton =
    button [ Html.Events.onClick Login ] [ text "Login" ]


mainView : Model -> Html Msg
mainView model =
    let
        authSection =
            case model.userToken of
                Nothing ->
                    div [] [ loginForm model, loginButton ]

                Just token ->
                    div [] [ text "Logout" ]
    in
        div []
            [ p [] [ text model.error ]
            , usersSection model
            , p [] [ text (Maybe.withDefault "Not logged" model.userToken) ]
            , authSection
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
