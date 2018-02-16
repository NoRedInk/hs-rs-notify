import FLib
import Protolude

import Foreign.C.String (newCString)

main :: IO ()
main = do
  str <- newCString "Hello World\0"
  printString str
