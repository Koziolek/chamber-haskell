module Lib where

browar :: String -> Bool
browar "IPA" = True
browar "ALE" = True
browar _ = False

gt10 :: Int -> String

gt10 i
    | i > 10 = "OK"
    | i <= 10 = "NOK"
