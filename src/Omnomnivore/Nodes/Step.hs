{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Omnomnivore.Nodes.Step where

import Data.Greskell.GraphSON (FromGraphSON(..))
import Data.Greskell.Graph
  ( AVertex, ElementData, Element, Vertex, Key
  )
import Data.Greskell.GTraversal ( Walk, SideEffect )
import Data.Greskell.Extra (writeKeyValues, (<=:>))
import Data.Greskell.Binder (Binder)
import Data.Text (Text)
import Omnomnivore.Relations (LinearRelation)
import Omnomnivore.Graph (Graph, allV, askGraphSource)
import Data.Greskell.GTraversal (Transform, GTraversal, gHasLabel, Walk, WalkType, (&.))
import Data.Greskell.Graph (Vertex)
import Data.Functor ((<&>))

import Data.Greskell.GTraversal (sAddV,  (<*.>))

type StepDescription = Text
data Step = -- | A step is a transformation from input ingredients to output ingredients with respect to the given quantities of input and output.
    Step
    { -- | Text describing how the step is performed.
      stepDescription :: StepDescription
    , -- | The transformation from the requested amount factor to time needed to perform the step.
      stepTimeRelation :: LinearRelation 
    } deriving (Show, Eq)

newtype VStep = -- | Define a vertex type for Step
  VStep AVertex
  deriving (Show, Eq, FromGraphSON, ElementData, Element, Vertex)

isStep :: (Element s, WalkType c) => Walk c s s
isStep = gHasLabel "person"

allSteps :: Graph (GTraversal Transform () VStep)
allSteps = allV <&> (&. isStep)

keyStepDescription :: Key VStep StepDescription
keyStepDescription = "description"

keyTimeRelation :: Key VStep LinearRelation
keyTimeRelation = "timeRelation" 

-- | Write 'Step' properties into a 'VStep' vertex.
writeStep :: Step -> Binder (Walk SideEffect VStep VStep)
writeStep Step{..} = writeKeyValues <$> (sequence $
                [ keyStepDescription <=:> stepDescription
                , keyTimeRelation <=:> stepTimeRelation
                ])

-- | Add a new 'VStep' vertex to the graph
addStep :: Step -> Graph (Binder (GTraversal SideEffect () VStep))
addStep p = askGraphSource >>= \graphSource -> return (writeStep p <*.> (pure $ sAddV "step" $ graphSource))
