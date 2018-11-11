module Main where

import Domain
import Lib
import Control.Monad
import Control.Monad.Reader
import Control.Monad.Except
import Data.Functor.Identity

main :: IO ()
main = do
    let config = Config "host" 8080
    result <- runExceptT $ runReaderT program config
    handleResult result
        where
            program = forever askFetch
            handleResult (Right _) = return ()
            handleResult (Left error) = putStrLn $ show error

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

type Effect e = ReaderT Config (ExceptT Error IO) e

askFetch :: Effect ()
askFetch = do
    cityName <- (lift.lift) $ askQuestion "What is next city?"
    city <- lift $ ExceptT ( return $ cityByName cityName )
    host <- mapReaderT (\ i -> return $ runIdentity i ) fetchHost
    port <- mapReaderT (       return . runIdentity ) fetchPort
--     let host = ""
--     let port = 8080
    forecast <- (lift.lift) $ thirdParty host port city
    (lift.lift) $ putStrLn $ "Forecast for city " ++ show city ++ " is " ++ show forecast