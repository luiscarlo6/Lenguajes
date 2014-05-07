module Effects where
import qualified System.IO as SIO 

import qualified Graphics.HGL as G

data Effects = Say String
             | Up
             | Down
             | Left
             | Right
             | Backwards
             | UpsideDown
             | Negative
             | Delay Integer
             | Color G.Color
             | Repeat Integer [Effects]
             | Forever [Effects]
             deriving (Show, Read, Eq)

readDisplayInfo :: SIO.Handle -> IO [Effects]
readDisplayInfo h =  do e <- SIO.hGetContents h
                        return $ map (\ x -> read x::Effects) $  lines e 
