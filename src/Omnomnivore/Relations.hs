{-# LANGUAGE NamedFieldPuns #-}

module Omnomnivore.Relations where

data LinearRelation = LinearRelation {a :: Double, b :: Double}
-- ^ A `LinearRelation` represents a linear relation in the form `ax + b`

scaleWith :: LinearRelation -> Double -> Double
scaleWith LinearRelation {a, b} = (+ b) . (* a)