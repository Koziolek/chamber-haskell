module Main where

import Domain
import Lib
import Control.Monad.Reader
import Data.Functor.Identity

main :: IO ()
main = return ()

fetchHost :: Reader Config Host
fetchHost = asks _host

fetchPort :: Reader Config Port
fetchPort = asks _port

askQuestion :: String -> IO String
askQuestion question = do
    putStrLn question
    getLine

-- cityByName :: String -> City
-- cityByName str = City str
cityByName :: String -> Either Error City
cityByName "Wrocław" = Right $ City "Wrocław"
cityByName "Cadiz" = Right $ City "Cadiz"
cityByName "Londyn" = Right $ City "Londyn"
cityByName name = Left $ UnknownCity name

type Effect e = ReaderT Config IO e

askFetch :: Effect ()
askFetch = do
    cityName <- lift $ askQuestion "What is next city?"
    city <- cityByName cityName
    host <- mapReaderT (\ i -> return $ runIdentity i ) fetchHost
    port <- mapReaderT (       return . runIdentity ) fetchPort
--     let host = ""
--     let port = 8080
    forecast <- lift $ thirdParty host port city
    lift $ putStrLn $ "Forecast for city " ++ show city ++ " is " ++ show forecast