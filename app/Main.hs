{-# LANGUAGE OverloadedStrings #-}

module Main where

import Omnomnivore.Graph
import Omnomnivore.Relations
import Omnomnivore.Nodes.Step
import Control.Monad.IO.Class (liftIO)
import Network.Greskell.WebSocket (submit, submitPair, slurpResults, drainResults)
import Data.Greskell.Binder (Binder, runBinder) -- from greskell package
import Data.Foldable (toList)
  
main :: IO ()
main = withGraph "localhost" 8182 "g" $ do
    client <- askGraphClient
    addStepQuery <- addStep Step
        { stepDescription = "Test Description"
        , stepTimeRelation = LinearRelation { a = 1, b = 2 }
        }
    liftIO $ submitPair client (runBinder addStepQuery) >>= drainResults
    return ()
    -- result_handle <- liftIO (submit client allSteps Nothing)
    -- liftIO $ print $ toList <$> slurpResults result_handle
    -- liftIO $ putStrLn "Hello, Haskell!"