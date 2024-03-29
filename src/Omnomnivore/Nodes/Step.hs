module Omnomnivore.Nodes.Step where

import Data.Text (Text)
import Omnomnivore.Relations (LinearRelation)

type Description = Text

data Step = -- | A step is a transformation from input ingredients to output ingredients with respect to the given quantities of input and output.
    Step
    { -- | Text describing how the step is performed.
      stepDescription :: Description
    , -- | The transformation from the requested amount factor to time needed to perform the step.
      stepTimeRelation :: LinearRelation
    }
