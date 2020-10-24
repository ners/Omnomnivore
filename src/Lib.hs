{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE RecordWildCards #-}

module Lib where

import Data.Text
import Data.Ratio

import Data.Greskell.Graph (AVertex, AEdge, ElementData, Element, Vertex, Edge, Key)
import Data.Greskell.GraphSON (FromGraphSON)
import Data.Greskell.Extra (writeKeyValues, (<=:>), (<=?>))
import Data.Greskell.Binder (Binder)
import Data.Greskell.GTraversal (GTraversal, Walk, SideEffect, source, sAddV, (<*.>))

type RecipeName = Text
type Essential = Bool

data Recipe = Recipe
    { recipeName :: RecipeName
    } deriving (Show, Eq)

newtype VRecipe = VRecipe AVertex
    deriving (Eq, Show, FromGraphSON, ElementData, Element, Vertex)

keyRecipeName :: Key VRecipe RecipeName
keyRecipeName = "name"

data RequiredQuantity = RequiredQuantity
    { a :: Rational
    , b :: Rational
    } deriving (Show, Eq)

data Dependency = Dependency
    { requiredQuantity :: RequiredQuantity
    , essential :: Essential
    } deriving (Show, Eq)

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