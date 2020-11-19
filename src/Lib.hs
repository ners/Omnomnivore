{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib where

import Data.Default
import Data.Text
import Data.Ratio

import Data.Greskell.Graph (AVertex, AEdge, ElementData, Element, Vertex, Edge, Key)
import Data.Greskell.GraphSON (FromGraphSON)
import Data.Greskell.Extra (writeKeyValues, (<=:>), (<=?>))
import Data.Greskell.Binder (Binder, newBind)
import Data.Greskell.GTraversal
    ( GTraversal, Walk, SideEffect, source, 
      sAddV, (<*.>), gAddE, gHas2, gProperty,
      gTo, gV
    )
import Control.Category ((>>>))
import Data.Aeson (ToJSON) 
import GHC.Generics

type RecipeName = Text
type Essential = Bool

data Recipe = Recipe
    { recipeName :: RecipeName
    } deriving (Show, Eq)

newtype VRecipe = VRecipe AVertex
    deriving (Eq, Show, FromGraphSON, ElementData, Element, Vertex)

keyRecipeName :: Key VRecipe RecipeName
keyRecipeName = "name"

-- | The parameters to the linear equation that relates requested amounts with required amounts using the following formula:
-- >>> a * requested outcome amount + b
-- Examples:
--     * 350 ml of mayonnaise requires 15 ml of vinegar: @{ a = 15/350, b = 0 }@
--     * Espresso requires 7 g of ground coffee per shot: @{ a = 7, b = 0 }@
--     * Ground coffee requires 1 g of coffee beans per 1 g of requested grounds: @{ a = 1, b = 0 }@
--     * Some cooked rice recipes require equal parts water and rice, plus a half cup of water.
--       Assuming the rice doubles in mass while cooking: @{ a = 1/2, b = 0 }@ cups of rice and @{ a = 1/2, b = 1/2 }@ cups of water.
--       Note: if we want to equate cooked rice and raw rice quantities (100 g cooked rice needs 100 g raw rice), let both a = 1.
data RequiredQuantity = RequiredQuantity
    { -- | Ratio of the ingredient amount to requested recipe amount
      a :: Rational
      -- | Additional constant quantity
    , b :: Rational
    } deriving (Show, Eq, Generic)

instance Default RequiredQuantity where
    def = RequiredQuantity { a = 1, b = 0 }

-- | An edge type between two recipes, specifying the amount needed.
data Dependency = Dependency
    { -- | The amount of the target recipe needed
      requiredQuantity :: RequiredQuantity
      -- | Whether or not this dependency can be dropped or substituted
    , essential :: Essential
    } deriving (Show, Eq, Generic)

instance ToJSON RequiredQuantity
instance ToJSON Dependency

newtype EDependency = EDependency AEdge
    deriving (Eq, Show, FromGraphSON, ElementData, Element, Edge)

keyDependencyQuantity :: Key EDependency RequiredQuantity
keyDependencyQuantity = "quantity"

keyDependencyEssential :: Key EDependency Essential
keyDependencyEssential = "essential"

writeRecipe :: Recipe -> Binder (Walk SideEffect VRecipe VRecipe)
writeRecipe Recipe{..} = writeKeyValues <$> sequence
    [ keyRecipeName <=:> recipeName
    ]

addRecipe :: Recipe -> Binder (GTraversal SideEffect () VRecipe)
addRecipe r = writeRecipe r <*.> (pure $ sAddV "recipe" $ source "g")

writeDependency :: Dependency -> Binder (Walk SideEffect EDependency EDependency)
writeDependency Dependency{..} = writeKeyValues <$> sequence
    [ keyDependencyEssential <=:> essential,
      keyDependencyQuantity <=:> requiredQuantity
    ]

addDependency :: RecipeName -> Dependency -> Binder (Walk SideEffect VRecipe EDependency)
addDependency target_name dep = do
    vtarget <- newBind target_name
    vess <- newBind (essential dep)
    vquant <- newBind (requiredQuantity dep)
    return $
        gAddE "requires" (gTo (gV [] >>> gHas2 keyRecipeName vtarget)) >>> gProperty keyDependencyEssential vess >>> gProperty keyDependencyQuantity vquant

-- addDependency :: RecipeName -> RecipeName -> Dependency -> Binder (Walk SideEffect VRecipe VRecipe EDependency)
-- Something like this?
-- I thought the idea was to take vertices, hmm
-- Let's have a getRecipeByName function

getRecipeByName :: RecipeName -> ...