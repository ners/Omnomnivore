{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE DeriveAnyClass #-}

module Omnomnivore.Relations where

import GHC.Generics
import Data.Aeson.Types (ToJSON, FromJSON)

data LinearRelation = -- | Represents a linear relation in the form `ax + b`.
    LinearRelation
    { -- | The linear coefficient.
      a :: Double
    , -- | The constant coefficient.
      b :: Double
    } deriving (Show, Eq, Generic, ToJSON, FromJSON)

-- | Compute the linear relation `ax + b` with given `x`.
scaleWith :: LinearRelation -> Double -> Double
scaleWith LinearRelation{a, b} = (+ b) . (* a)
