module SignupForm where


import Effects
import StartApp
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class)

--MODEL
initialErrors =
    { username = "", password = ""}


initialModel = 
    { username = "", password = "", errors = initialErrors}


--VIEW
view actionDispatcher model =
    form [ id "signup-form" ] [
        h1 [] [ text "Sensational Signup Form" ]
        , label [ for "username-field" ] [ text "Username:" ]
        , input 
            [ id "username-field"
            , type' "text"
            , value model.username
            , on "input" targetValue (\str -> Signal.message actionDispatcher 
                {actionType = "SET_USERNAME", payload = str}) 
            ] 
            []
        , div [ class "validation-error" ] [ text model.errors.username ]
        , label [ for "password" ] [ text "password:" ]
        , input 
            [ id "password-field"
            , type' "password"
            , value model.password 
            , on "input" targetValue (\str -> Signal.message actionDispatcher
                {actionType = "SET_PASSWORD", payload = str })
            ] 
            []
        , div [ class "validation-error" ] [ text model.errors.password ]
        , div [ class "signup-button", onClick actionDispatcher 
                {actionType = "VALIDATE", payload = "" } ] [ text "Sign Up!" ]
    ]


--UPDATE
getErrors model =
    { username = 
        if model.username == "" then
            "Please enter a username!"
        else
            ""

    , password = 
        if model.password == "" then
            "Please enter a password!"
        else
            ""
    }   


update action model =
    if 
        | action.actionType == "VALIDATE" ->
            ( { model | errors <- getErrors model }, Effects.none )
        | action.actionType == "SET_USERNAME" ->
            ( { model | username <- action.payload }, Effects.none )
        | action.actionType == "SET_PASSWORD" ->
            ( { model | password <- action.payload }, Effects.none )
        | otherwise ->
            ( model, Effects.none )


--START
app = 
    StartApp.start 
        { init = ( initialModel, Effects.none)
        , update = update
        , view = view
        , inputs = []
        }


main =
    app.html
