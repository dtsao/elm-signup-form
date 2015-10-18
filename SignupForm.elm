module SignupForm where


import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class)

view model =
    form [ id "signup-form" ] [
        h1 [] [ text "Sensational Signup Form" ]
        , label [ for "username-field" ] [ text "Username:" ]
        , input [ id "username-field", type' "text", value model.username ] []
        , label [ for "password" ] [ text "password:" ]
        , input [ id "password-field", type' "password", value model.password ] []
        , div [ class "signup-button"] [ text "Sign Up!" ]
    ]

main =
    view { username = "", password = ""}    