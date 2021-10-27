{-# LANGUAGE OverloadedStrings #-}

module Test (tests) where

import Data.Text.Format (format, shortest)
import Data.Text.Lazy (unpack)
import Distribution.TestSuite (Progress (Finished), Result (Fail, Pass), Test (Test), TestInstance (TestInstance, name, options, run, setOption, tags))
import Omnomnivore.Relations (LinearRelation (LinearRelation, a, b), scaleWith)

tests :: IO [Test]
tests = do
  return checkLinearRelations

checkLinearRelations :: [Test]
checkLinearRelations =
  [ linearRelationCheck "just a" LinearRelation {a = 2, b = 0} 4 8,
    linearRelationCheck "just b" LinearRelation {a = 0, b = 2} 999 2,
    linearRelationCheck "both a and b" LinearRelation {a = 1.5, b = 3} 5 10.5
  ]

linearRelationCheck name relation i o =
  Test
    TestInstance
      { name = name,
        tags = ["card", "description"],
        options = [],
        setOption = noOptions,
        run = return (Finished toResult)
      }
  where
    noOptions = \_ _ -> Left "Not supported"
    toResult = if scaleWith relation i == o then Pass else Fail $ unpack errorString
    errorString = format "{} != {}" (shortest $ scaleWith relation i, shortest o)
