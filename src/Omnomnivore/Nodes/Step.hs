module Omnomnivore.Nodes.Step where

import Data.Text (Text)
import Omnomnivore.Relations (LinearRelation)

type Description = Text

data Step = Step
  { stepDescription :: Description,
    stepInputRelation :: LinearRelation
  }