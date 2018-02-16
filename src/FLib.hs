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
import System.FilePath

data Event
  = NoticeWrite FilePath
  | NoticeRemove FilePath
  | Create FilePath
  | Write FilePath
  | Chmod FilePath
  | Remove FilePath
  | Rename FilePath
           FilePath
  | Rescan
  | Error T.Text
          (Maybe FilePath)
  | Unknown
  deriving (Show)

foreign import ccall "watch_for_changes" watchForChanges ::
               CString -> FunPtr (CString -> CString -> CString -> IO ()) -> IO ()

foreign import ccall "wrapper" mkCallback ::
               (CString -> CString -> CString -> IO ()) ->
                 IO (FunPtr (CString -> CString -> CString -> IO ()))

watch :: T.Text -> (Event -> IO ()) -> IO ()
watch path callback = do
  mVar <- newMVar Nothing
  cb <- mkCallback $ forkCallback mVar callback
  pathCStr <- newCString $ T.unpack path
  watchForChanges pathCStr cb

forkCallback ::
     MVar (Maybe ThreadId)
  -> (Event -> IO ())
  -> CString
  -> CString
  -> CString
  -> IO ()
forkCallback mVar cb eventC aC bC = do
  eventStr <- T.pack <$> peekCString eventC
  a <- T.pack <$> peekCString aC
  b <- T.pack <$> peekCString bC
  let event = toEvent eventStr a b
  runningThread <- takeMVar mVar
  _ <- traverse_ killThread runningThread
  threadId <- forkIO (cb event)
  putMVar mVar (Just threadId)

toEvent :: T.Text -> T.Text -> T.Text -> Event
toEvent "NoticeWrite" _ b = NoticeWrite (T.unpack b)
toEvent "NoticeRemove" _ b = NoticeRemove (T.unpack b)
toEvent "Create" _ b = Create (T.unpack b)
toEvent "Write" _ b = Write (T.unpack b)
toEvent "Chmod" _ b = Chmod (T.unpack b)
toEvent "Remove" _ b = Remove (T.unpack b)
toEvent "Rename" a b = Rename (T.unpack a) (T.unpack b)
toEvent "Rescan" _ _ = Rescan
toEvent "Error" msg path =
  Error
    msg
    (case path of
       "" -> Nothing
       _ -> Just (T.unpack path))
toEvent _ _ _ = Unknown
