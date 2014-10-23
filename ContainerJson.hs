{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module ContainerJson
       ( parseProcessId
       ) where

import           Data.Aeson
import qualified Data.Aeson.Types as ATS
import qualified Data.ByteString.Lazy.UTF8 as U
import           Data.Maybe
import           Options.Applicative

-- import           Debug.Trace

parseProcessId :: String -> Maybe Integer
parseProcessId containerJson = do
  jsonArr <- decode (U.fromString containerJson) :: Maybe [Value]
  jsonVal <- listToMaybe jsonArr
  pid <- ATS.parseMaybe (extractPid) jsonVal
  return pid

  where extractPid :: Value -> ATS.Parser Integer
        extractPid (Object o) = do
          s <- o .: "State"
          p <- s .: "Pid"
          return p

        extractPid x = error $ "Failed to parse State/Pid from " <> (show x)
