{-# LANGUAGE OverloadedStrings #-}

module Omnomnivore.Graph where

import Control.Monad.Reader (ReaderT (runReaderT), MonadReader (ask))
import Network.Greskell.WebSocket (Client, Host, Port, connect, close)
import Data.Greskell (Greskell, GraphTraversalSource, source)
import Data.Text (Text)
import Control.Exception (bracket)

data GraphData = GraphData
  { graphClient :: Client,
    graphSource :: Greskell GraphTraversalSource
  }

type Graph a = ReaderT GraphData IO a

askGraphSource :: Graph (Greskell GraphTraversalSource)
askGraphSource = ask >>= \x -> return (graphSource x)

askGraphClient :: Graph Client
askGraphClient = ask >>= \x -> return (graphClient x)

withGraph :: Host -> Port -> Text -> Graph a -> IO a
withGraph host port sourceName a = do
  bracket (connect host port) close $ \client ->
    runReaderT a GraphData {graphClient = client, graphSource = source sourceName}