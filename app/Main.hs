{-# LANGUAGE OverloadedStrings #-}

module Main where

import Omnomnivore.Graph

main :: IO ()
main = withGraph "localhost" 8182 "g" $ do
    client <- askGraphClient
    return ()