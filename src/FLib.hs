{-|
Module      : FLib
Description : FLib's main module

This is a haddock comment describing your library
For more information on how to write Haddock comments check the user guide:
<https://www.haskell.org/haddock/doc/html/index.html>
-}
module FLib where

import Foreign.C.String
import Protolude

foreign import ccall unsafe "print_string" printString ::
               CString -> IO ()
