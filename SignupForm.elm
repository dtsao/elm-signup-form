module SignupForm where


import Http
import Task exposing (Task)
import Json.Decode exposing (succeed)
import StartApp
import Effects
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class)

--MODEL
initialErrors =
    { username = "", password = "", usernameTaken = False }


initialModel = 
    { username = "", password = "", errors = initialErrors}


--VIEW
viewUsernameErrors model =
    if model.errors.usernameTaken then
        "That username is taken!"
    else
        model.errors.username


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
        , div [ class "validation-error" ] [ text (viewUsernameErrors model) ]
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

    , usernameTaken = 
        model.errors.usernameTaken
    }   


withUsernameTaken isTaken model =
    let
        currentErrors =
            model.errors

        newErrors = 
            {currentErrors | usernameTaken <- isTaken }
    in 
        { model | errors <- newErrors }


update action model =
    if 

        | action.actionType == "VALIDATE" ->
            let
                url =
                    "https://api.github.com/users/" ++ model.username
                usernameTakenAction =
                    { actionType = "USERNAME_TAKEN", payload = "" }
                usernameAvailableAction =
                    { actionType = "USERNAME_AVAILABLE", payload = "" }
                request =
                    Http.get (succeed usernameTakenAction) url
                neverFailingRequest =
                    Task.onError request (\err -> Task.succeed usernameAvailableAction)
            in
                ({ model | errors <- getErrors model }, Effects.task neverFailingRequest)
        | action.actionType == "SET_USERNAME" ->
            ( { model | username <- action.payload }, Effects.none )
        | action.actionType == "SET_PASSWORD" ->
            ( { model | password <- action.payload }, Effects.none )
        | action.actionType == "USERNAME_TAKEN" ->
            ( withUsernameTaken True model, Effects.none )
        | action.actionType == "USERNAME_AVAILABLE" ->
            ( withUsernameTaken False model, Effects.none )
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


port tasks : Signal (Task Effects.Never ())
port tasks =
    app.tasks


main =
    app.html
