import FLib
import Protolude

main :: IO ()
main = do
  watch "/Users/stoeffel/nri/noredink" callback
  putText "done"

callback :: IO ()
callback = putText "changed"
