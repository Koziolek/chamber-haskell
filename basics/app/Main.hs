{-# LANGUAGE FlexibleInstances #-}
module Main where

import Lib

-- nowy typ

--type constructor = date constructor
data  MyBool = MyFalse | MyTrue
-- type class imp
    deriving Show
-- z argumentami

data Shape a = Rectangle a a | Circle a

instance Show a => Show (Shape a) where
    show (Rectangle a a2)= "dupa"
    show (Circle r)= "dupa r"

someShape :: Shape Int
someShape = Circle 10

main :: IO ()
main = askQuestion "Jak masz na imię" *> (return ())


askQuestion :: String -> IO ()
askQuestion question =
    (putStrLn question)
        *> (getLine
            >>= ( \a -> putStrLn $ "Miło cię poznać " ++ a)
            )


askQuestion2 :: String -> IO ()
askQuestion2 question = do
    putStrLn question
    a <- getLine
    putStrLn $ "Miło cię poznać " ++ al

