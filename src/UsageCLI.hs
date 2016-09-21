{-# LANGUAGE QuasiQuotes #-}
module UsageCLI (progUsage) where

import System.Environment (getArgs)
import System.Console.Docopt

progUsage :: Docopt
progUsage = [docopt|
genpdf-preview.

Usage:
    huntex FILE [ -m MAP ] -t TITLE -s SUBDIR
    huntex --help | -h
    huntex --version

Options:
    -m, --map MAP          Map 'BASE:URL' from BASE directory to URL [ '~/Dropbox/Public:www.dropbox.com/u/xyz' ]
    -t, --title TITLE      Link title
    -s, --subdir SUBDIR    Directory in which previews and files will be stored (BASE should be a prefix of SUBDIR)
    -h, --help             Show help
    --version              Show version.

Arguments
    FILE                   PDF file to be analyzed
|]
