port module Main exposing (main)

import Worker


{-| We'll receive messages from the world in the form of strings here
-}
port messagesIn : (String -> msg) -> Sub msg


{-| This port will send our counter back out to the world
-}
port modelOut : Model -> Cmd msg


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    let
        _ =
            Debug.log "Screep" "Hello World"
    in
        ( 0, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


{-| In this function we define `parse` in order to go from
the strings that the outside world sends us to the messages our
program knows about. We then pass `parse` to `messagesIn` to get
a subscription that can update our program from things that happen
in JavaScript-land
-}
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| The first argument to Worker.worker lets us wrap our update
function with additional Cmds to execute on every change. In this
case we want to send our model out to JS on every update so we
pass it our `modelOut` port. We are already receiving messages from
our `messagesIn` port via `subscriptions` so now we're fully connected
to the JavaScript side of the application!
-}
main : Program Never
main =
    Worker.program modelOut
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
