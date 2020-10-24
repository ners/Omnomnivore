{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Data.Ratio
import Control.Monad (forM)
import Control.Monad.IO.Class (liftIO)

import Control.Exception.Safe (bracket, try, SomeException)
import Data.Foldable (toList)
import Data.Greskell.Greskell (Greskell) -- from greskell package
import Data.Greskell.Binder -- from greskell package
  (Binder, newBind, runBinder)
import Network.Greskell.WebSocket -- from greskell-websocket package
  (connect, close, submit, slurpResults)
import System.IO (hPutStrLn, stderr)

main :: IO ()
main = do
    bracket (connect "localhost" 8182) close $ \client -> do
        let r1 = Recipe { recipeName = "mayonnaise" }
        let r2 = Recipe { recipeName = "cappuccino" }

        recipes <- forM [r1, r2] $ \recipe -> do
            let (g, binding) = runBinder $ addRecipe recipe
            result_handle <- submit client g (Just binding)
            toList <$> slurpResults result_handle
        
        liftIO $ print recipes