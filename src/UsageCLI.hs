{-# LANGUAGE QuasiQuotes #-}
module UsageCLI (progUsage, defaultmap) where

import System.Environment (getArgs)
import System.Console.Docopt

defaultmap               = "/Users/zaccaria/Dropbox/Public/:dl.dropboxusercontent.com/u/5867765"

progUsage :: Docopt
progUsage = [docopt|
genpdf-preview.

Usage:
    genpdf-preview FILE [ -m MAP ] -t TITLE -s SUBDIR [ -g ]
    genpdf-preview --help | -h
    genpdf-preview --version

Options:
    -m, --map MAP          Map 'BASE:URL' from BASE directory to URL ["/Users/zaccaria/Dropbox/Public/:dl.dropboxusercontent.com/u/5867765"]
    -t, --title TITLE      Link title
    -s, --subdir SUBDIR    Directory in which previews and files will be stored (BASE should be a prefix of SUBDIR)
    -h, --help             Show help
    -g, --go               Launch conversion, otherwise dry run
    --version              Show version.

Arguments
    FILE                   PDF file to be analyzed
|]
