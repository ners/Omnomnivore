module Omnomnivore.Nodes.Ingredient where

import Data.Text (Text)

type Name = Text
type Description = Text

data Terminal = Terminal | Composite
data Quantification = Mass Double | Volume Double | Quantity Integer

isQuantised :: Quantification -> Bool 
isQuantised (Quantity _) = True
isQuantised _ = False

data Ingredient = Ingredient { 
    name :: Name,
    quantification :: Quantification,
    terminal :: Terminal
} 
