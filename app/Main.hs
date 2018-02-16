import FLib
import Protolude

main :: IO ()
main = do
  watch "/Users/stoeffel/nri/noredink" callback
  putText "done"

callback :: IO ()
callback = do
  putText "changed"
  threadDelay 10000000
  putText "done"
