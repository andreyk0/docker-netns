{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecordWildCards #-}

module Main
  where

import           Control.Exception
import           HSH
import           Options.Applicative

--import           Debug.Trace

import           ContainerJson

data CmdLineOpts =
  CmdLineOpts { containerId :: String
               , exeName :: String
               , exeArgs :: [String]
               } deriving (Show)

parseArgs :: Parser CmdLineOpts
parseArgs =
  CmdLineOpts <$> argument str (metavar "CONTAINER_ID")
              <*> argument str (metavar "EXECUTABLE")
              <*> many (argument str (metavar "ARGS..." ))


main :: IO ()
main = execParser opts >>= runMain
  where
    opts = info (helper <*> parseArgs) $
             fullDesc
             <> progDesc "Wraps up some steps mentioned in https://docs.docker.com/articles/runmetrics/ (ip netns section), needs sudo access."
             <> header "Executes given command in the docker container's netwok namespace."
             <> footer "E.g. docker-netns -- 9ef24eba0123 netstat -anp"


runMain :: CmdLineOpts -> IO ()
runMain cmd = do
  let CmdLineOpts{..} = cmd
  containerJson <- run $ ("docker", ["inspect", containerId]) :: IO String

  let pid = case parseProcessId containerJson
                 of Just x -> x
                    Nothing -> error $ "Couldn't extract container process ID from the output of docker inspect"

  runIO $ ("mkdir", ["-pv", "/var/run/netns"])
  let nsname = (show pid) <> "-" <> containerId
  _ <- bracket (runIO $ ("ln", ["-s", "/proc/" <> (show pid) <> "/ns/net", "/var/run/netns/" <> nsname]))
               (\_ -> runIO $ ("rm", ["-f", "/var/run/netns/" <> nsname]))
               (\_ -> runIO $ ("ip", "netns" : "exec" : nsname : exeName : exeArgs))

  return ()
