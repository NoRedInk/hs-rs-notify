{-|
Module      : FLib
Description : FLib's main module

This is a haddock comment describing your library
For more information on how to write Haddock comments check the user guide:
<https://www.haskell.org/haddock/doc/html/index.html>
-}
module FLib where

import Control.Exception (bracket)
import Control.Monad (when)
import Foreign.C.String
import Foreign.ForeignPtr
import Foreign.Ptr
import Protolude

foreign import ccall "watch_for_changes" watchForChanges ::
               FunPtr (IO ()) -> IO ()

foreign import ccall "wrapper" mkCallback ::
               IO () -> IO (FunPtr (IO ()))
