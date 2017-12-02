module Route exposing (Route(..), route, href, fromLocation)

{-| Routing logic for the application.
-}

import Data.Room as Room
import Navigation exposing (Location)
import Html exposing (Attribute)
import Html.Attributes as Attr
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Route
    = Conversations
    | Room String -- TODO: Create a strong type for the room id param


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Conversations (s "")
        , Url.map Room (s "rooms" </> Room.slugParser)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Conversations ->
                    []

                Room slug ->
                    [ "rooms", slug ]
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Conversations
    else
        parseHash route location