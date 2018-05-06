import Data.Conduit.LZ4
import Data.Conduit
import Data.Conduit.Binary
import System.Environment
import System.IO

main :: IO ()
main = do
  args <- getArgs
  let conduit = case args of
       [] -> Just $ compress Nothing
       [arg] -> case reads arg of
         [(compression, "")] | compression < 0 -> Just decompress
         [(compression, "")] -> Just $ compress $ Just compression
         _ -> Nothing
       _ -> Nothing
  case conduit of
    Nothing -> help
    Just conduit' -> runConduitRes $ sourceHandle stdin .| conduit' .| sinkHandle stdout
  where
  help = hPutStrLn stderr "optionally supply acceleration value (Int) as first argument (any negative number for decompression)\ntool will then use stdin/stdout"
