{-# LANGUAGE FlexibleInstances, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Lib (process) where

import Prelude (String, IO, ShowS, showString, shows, fmap, (.))
import System.Environment (getProgName)
import System.IO (FilePath, hPutStrLn, hPrint, stderr, writeFile)
import System.Directory (listDirectory)
import System.FilePath.Posix (dropExtension)
import Data.String (IsString, fromString)
import Data.List (sort)

instance IsString ShowS where
  fromString = showString

process :: [String] -> IO ()
process args = do
    hPrint stderr args
    name <- getProgName
    migrationFiles <- listDirectory "./preprocessed/migrations"
    let modules = fmap dropExtension (sort migrationFiles)
    case args of
        src : _ : dst : args' -> do
            hPutStrLn stderr name
            hPrint stderr modules
            hPrint stderr args'
            writeFile dst (mkModule src)
        _ -> hPutStrLn stderr "Error"

mkModule :: FilePath -> String
mkModule src =
    ( "{-# LINE 1 " . shows src . " #-}\n"
    . showString "{-# OPTIONS_GHC -fno-warn-warnings-deprecations #-}\n"
    . showString "module Main where\n"
    . showString "main :: IO ()\n"
    . showString "main = putStrLn \"Preprocessed! Yay Again Dood!\""
    ) "\n"