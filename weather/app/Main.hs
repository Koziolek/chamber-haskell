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

fetchHost :: (MonadReader Config m) => m Host
fetchHost = asks _host

fetchPort :: (MonadReader Config m) => m Port
fetchPort = asks _port

askQuestion :: (MonadIO m ) => String -> m String
askQuestion question = do
    lifIO $ putStrLn question
    lifIO $ getLine

-- cityByName :: String -> City
-- cityByName str = City str
cityByName :: (MonadError Error m ) => String -> m City
cityByName "Wrocław" = return $ City "Wrocław"
cityByName "Cadiz" = return $ City "Cadiz"
cityByName "Londyn" = return $ City "Londyn"
cityByName name = throwError $ UnknownCity name

askFetch :: (
            MonadReader Config m,
            MonadIO m,
            MonadError Error m
    ) => m ()
askFetch = do
    cityName <- askQuestion "What is next city?"
    city <- cityByName cityName
    host <- fetchHost
    port <- fetchPort
    forecast <- liftIO $ thirdParty host port city
    liftIO $ putStrLn $ "Forecast for city " ++ show city ++ " is " ++ show forecast