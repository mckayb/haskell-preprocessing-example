module Main (main) where

import System.Environment (getArgs)
import Lib (process)

main :: IO ()
main = getArgs >>= process