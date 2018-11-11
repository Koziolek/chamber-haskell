module Lib where

data City = City String
    deriving Show
data Temp = Temp Int
    deriving Show

data Forecast = Forecast Temp
    deriving Show

-- newtype Host = Host String -- trochę jak VO
type Host = String -- trochę jak VO
type Port = Int -- alias

thirdParty :: Host-> Port -> City -> IO Forecast
thirdParty _ _ (City "Wrocław") = return $ Forecast $ Temp 7
thirdParty _ _ (City "Cadiz") = return $ Forecast $ Temp 25
thirdParty _ _ _ = fail "Andrzej to jebnie"