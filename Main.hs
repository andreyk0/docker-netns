module Main
  where

import           Control.Monad
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Lazy.UTF8 as U8
import           Data.List
import           Data.Ord
import           Options.Applicative
import           Options.Applicative.Builder
import           Text.Regex.TDFA
import           Text.Regex.TDFA.ByteString

import Debug.Trace

data ShellCommand =
  ShellCommand { exeName :: String
               , exeArgs :: [String]
               } deriving (Show)

parseArgs :: Parser ShellCommand
parseArgs =
  ShellCommand <$> argument str (metavar "EXECUTABLE")
               <*> many (argument str (metavar "ARGS..." ))


main :: IO ()
main = execParser opts >>= putStrLn . show
  where
    opts = info (helper <*> parseArgs) $
             fullDesc
             <> progDesc "Sorts lines of text using a few built-in functions: semver, date."
             <> header "Sorts lines of text using a few built-in functions."




