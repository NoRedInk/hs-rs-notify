import FLib
import Protolude

main :: IO ()
main = mkCallback helloFromHs >>= printString

helloFromHs :: IO ()
helloFromHs = putText "hello from haskell"
