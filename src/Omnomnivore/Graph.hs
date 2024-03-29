{-# LANGUAGE OverloadedStrings #-}

module Omnomnivore.Graph where

import Control.Exception (bracket)
import Control.Monad.Reader (MonadReader (ask), ReaderT (runReaderT))
import Data.Greskell (GraphTraversalSource, Greskell, source)
import Data.Text (Text)
import Network.Greskell.WebSocket (Client, Host, Port, close, connect)

data GraphData = GraphData
    { graphClient :: Client
    , graphSource :: Greskell GraphTraversalSource
    }

type Graph a = ReaderT GraphData IO a

askGraphSource :: Graph (Greskell GraphTraversalSource)
askGraphSource = ask >>= \x -> return (graphSource x)

askGraphClient :: Graph Client
askGraphClient = ask >>= \x -> return (graphClient x)

type GraphSourceName = Text

withGraph :: Host -> Port -> GraphSourceName -> Graph a -> IO a
withGraph host port sourceName a = do
    bracket (connect host port) close $ \client ->
        runReaderT a GraphData{graphClient = client, graphSource = source sourceName}
