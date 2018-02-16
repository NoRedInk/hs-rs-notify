import FLib
import Protolude

main :: IO ()
main = do
  cb <- mkCallback callback
  watchForChanges cb
  putText "done"

callback :: IO ()
callback = putText "hello from haskell"
