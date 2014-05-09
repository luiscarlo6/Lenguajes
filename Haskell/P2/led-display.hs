{-| 
  Module      : led-display.hs
  Copyright   : Universidad Simón Bolívar
  Maintainer  : Luiscarlo Rivera (09-11020) 
                & José Julián Prado (09-11006)
                & Grupo 9 Taller de Lenguajes de Programación I (CI-3661) 
                Entrega: Proyecto # 2
                 
  conteniendo el codigo fuente Haskell para el programa principal
-}

import qualified System.Environment as SE (getArgs)
import qualified System.IO as SIO 
import qualified Data.List as DL
import Pixels
import Effects

mensajeLC = "\nError: Deben haber al menos dos archivos en la linea de comandos\n"


main = do
  archivos <- SE.getArgs

  if DL.length archivos < 2 
    then error mensajeLC --Caso error en la linea de comandos
        
    else do fontEntrada1 <- SIO.openFile (DL.head archivos) SIO.ReadMode
            x <- readFont fontEntrada1
            y <- procesarArchivos (DL.tail archivos) []
            ledDisplay x y


-- | Procesa todos los archivos y retorna una lista con todos los efectos
procesarArchivos :: [FilePath] -> [Effects] -> IO [Effects]
procesarArchivos []  n    = return n
procesarArchivos (x:xs) n = do effects1 <- SIO.openFile (x) SIO.ReadMode
                               y <- readDisplayInfo effects1
                               procesarArchivos xs (n++y)
                                
