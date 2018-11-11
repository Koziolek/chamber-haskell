module Domain where

import Lib

data Config= Config {
    _host :: Host,
    _port :: Port
}
data Error = UnknownCity String