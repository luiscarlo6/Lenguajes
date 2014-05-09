{-| 
  Module      : Effects
  Copyright   : Universidad Simón Bolívar
  Maintainer  : Luiscarlo Rivera (09-11020) 
                & José Julián Prado (09-11006)
                & Grupo 9 Taller de Lenguajes de Programación I (CI-3661) 
                Entrega: Proyecto # 2
                 
  conteniendo el codigo fuente Haskell para implantar el tipo de datos Effects,
  ademas de las funciones que operan sobre ellos.
-}


module Effects where

--import qualified Data.List as DL
--import qualified Data.Char as DC
import qualified Data.Map as DM
--import qualified Graphics.HGL as G
import qualified Control.Concurrent as CC
import Pixels
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

             
-- | Permite obtener los @Effects@ a mostrar a partir 
-- | de un archivo dado
readDisplayInfo :: SIO.Handle -> IO [Effects]
readDisplayInfo h =  do e <- SIO.hGetContents h
                        let x = filter (/="") (lines e)
                        return (map (\y-> read y::Effects) x)
                        
                        

