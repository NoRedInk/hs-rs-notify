{-|
Module      : FLib
Description : FLib's main module

This is a haddock comment describing your library
For more information on how to write Haddock comments check the user guide:
<https://www.haskell.org/haddock/doc/html/index.html>
-}
module FLib where

import Control.Concurrent
import Control.Exception (bracket)
import Control.Monad (when)
import Data.Foldable
import Data.Text as T
import Foreign.C.String
import Foreign.ForeignPtr
import Foreign.Ptr
import Protolude

foreign import ccall "watch_for_changes" watchForChanges ::
               CString -> FunPtr (IO ()) -> IO ()

foreign import ccall "wrapper" mkCallback ::
               IO () -> IO (FunPtr (IO ()))

watch :: T.Text -> IO () -> IO ()
watch path callback = do
  mVar <- newMVar Nothing
  cb <- mkCallback $ forkCallback mVar callback
  pathCStr <- newCString $ T.unpack path
  watchForChanges pathCStr cb

forkCallback :: MVar (Maybe ThreadId) -> IO () -> IO ()
forkCallback mVar cb = do
  runningThread <- takeMVar mVar
  _ <- traverse_ killThread runningThread
  threadId <- forkIO cb
  putMVar mVar (Just threadId)
