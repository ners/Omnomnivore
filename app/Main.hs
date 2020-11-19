{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Control.Monad (forM)
import Control.Monad.IO.Class (liftIO)

import Control.Exception.Safe (bracket)
import Data.Foldable (toList)
 -- from greskell package
import Data.Greskell.Binder -- from greskell package
  (runBinder)
import Network.Greskell.WebSocket -- from greskell-websocket package
  (connect, close, submit, slurpResults)

main :: IO ()
main = do
    bracket (connect "localhost" 8182) close $ \client -> do
        let r1 = Recipe { recipeName = "mayonnaise" }
        let r2 = Recipe { recipeName = "cappuccino" }
        let r3 = Recipe { recipeName = "steamed milk" }
        let d1 = Dependency
          { requiredQuantity = def
          , essential = True
          }

        recipes <- forM [r1, r2, r3] $ \recipe -> do
            let (g, binding) = runBinder $ addRecipe recipe
            result_handle <- submit client g (Just binding)
            toList <$> slurpResults result_handle

        edges <- do
          let (g, binding) = runBinder $ addDependency "capuccino" d1
          result_handle <- submit client g (Just binding)
          toList <$> slurpResults result_handle


        liftIO $ mapM_ print recipes
        liftIO $ mapM_ print edges
      
    -- A good fox would add:
    --   addDependency
    --   getAllRecipes
    -- Then together we can addMhm
    --   getFullRecipe (full subgraph)