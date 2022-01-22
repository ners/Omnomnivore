{-# LANGUAGE NamedFieldPuns #-}

module Omnomnivore.Relations where

data LinearRelation = -- | Represents a linear relation in the form `ax + b`.
    LinearRelation
    { -- | The linear coefficient.
      a :: Double
    , -- | The constant coefficient.
      b :: Double
    }

-- | Compute the linear relation `ax + b` with given `x`.
scaleWith :: LinearRelation -> Double -> Double
scaleWith LinearRelation{a, b} = (+ b) . (* a)
