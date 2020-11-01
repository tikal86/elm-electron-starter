module Main exposing (..)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, h1, input, p, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Ipc
import IpcSerializer
import Ports


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Model =
    { counter : Int
    , name : String
    }


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { counter = 0, name = "" }, Cmd.none )


type Msg
    = Increment
    | Decrement
    | SendIpc Ipc.Msg
    | NameChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

        SendIpc ipcMsg ->
            ( model, sendIpcCmd ipcMsg )

        NameChanged newName ->
            ( { model | name = newName }, Cmd.none )


sendIpcCmd : Ipc.Msg -> Cmd Msg
sendIpcCmd ipcMsg =
    ipcMsg
        |> IpcSerializer.serialize
        |> Ports.sendIpc


view : Model -> Browser.Document Msg
view model =
    {title = "Visualisation title"
    , body = [div []
        [ h1 [] [ text "Welcome!" ]
        , p [] [ text "Change this file and save to see hot module replacement! ." ]
        , button [ onClick Decrement ] [ text "-" ]
        , button [ onClick Increment ] [ text "+" ]
        , div [] [ text (Debug.toString model) ]
        , input [ placeholder "Andre", value model.name, onInput NameChanged ] []
        , button [ onClick (SendIpc Ipc.GreetingDialog) ] [ text "Greeting Dialog" ]
        , button [ onClick (SendIpc Ipc.Quit) ] [ text "Quit" ]
        ]]
    }
