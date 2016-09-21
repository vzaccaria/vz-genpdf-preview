{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import System.Environment (getArgs)
import System.Console.Docopt.NoTH
import System.Process
import Data.String
import System.Exit
import qualified Data.Map as M
import Control.Monad (when)
import UsageCLI (progUsage, defaultmap)
import qualified Data.Text as T
import Debug.Trace
import Filesystem.Path.CurrentOS -- Enables fromString!

split :: String -> String -> [String]
split sep str = map T.unpack $ T.splitOn (T.pack sep) (T.pack str)

dispatchOptions :: Docopt -> IO ()
dispatchOptions usage = do {
  opts <- parseArgsOrExit usage =<< getArgs;
  file <- getArgOrExitWith usage opts (argument "FILE");
  let
      hasLOpt       name = (isPresent opts (longOption name))
      getLOptVal    name = let (Just s) = getArg opts (longOption name) in s


      dryrun                   = not (isPresent opts (longOption "go"))
      run                      = if dryrun then (\c -> do { putStrLn c; return ExitSuccess}) else system
      mapping                  = if (hasLOpt "map") then getLOptVal "map" else defaultmap
      [locprefix , remprefix ] = split ":" mapping

      fname                    = filename $ fromString file
      imgname                  = replaceExtension fname (T.pack "png") 

      title                    = getLOptVal "title"
      subdir                   = getLOptVal "subdir"


      lp' = fromString locprefix
      sd' = fromString subdir

  in do {
    case stripPrefix lp' sd' of
      (Just sd) -> do {
        run $ "mkdir -p " ++ subdir;
        run $ "convert -density 45 -depth 8 -quality 85 -delete 1--1 " ++ file ++ " " ++ subdir ++ "/" ++ (encodeString imgname);
        run $ "cp " ++ file ++ " " ++ subdir;
        let
          remurl                   = "https://" ++ remprefix ++ "/" ++ (encodeString sd) ++ "/" ++ (encodeString fname)
          remurlimg                = "https://" ++ remprefix ++ "/" ++ (encodeString sd) ++ "/" ++ (encodeString imgname)
        in putStrLn $ "Done.\nCopy the following into the yaml file\n\n  - key: " ++ title ++ "\n    value: " ++ remurl ++ "\n    img: " ++ remurlimg;
      }
      _ -> error $ "Sorry, " ++ (locprefix) ++ " should be a prefix of " ++ (subdir)
  };
  return ();
}


main :: IO ()
main = dispatchOptions progUsage
