import Notify
import Protolude

main :: IO ()
main = do
  watch "/Users/stoeffel/nri/noredink" [".elm"] callback
  putText "done"

callback :: Event -> IO ()
callback event = do
  putText "Callback"
  print event
  threadDelay 10000000
  putText "done"
