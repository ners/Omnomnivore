{-# LANGUAGE NamedFieldPuns #-}

module Omnomnivore.Relations where

data LinearRelation = LinearRelation
    -- ^ Represents a linear relation in the form `ax + b`.
    { a :: Double
    -- ^ The linear coefficient.
    , b :: Double
    -- ^ The constant coefficient.
    }

-- | Compute the linear relation `ax + b` with given `x`.
scaleWith :: LinearRelation -> Double -> Double
scaleWith LinearRelation {a, b} = (+ b) . (* a)