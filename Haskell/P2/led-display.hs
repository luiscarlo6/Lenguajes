{-| 
  Module      : led-display.hs
  Copyright   : Universidad Simón Bolívar
  Maintainer  : Luiscarlo Rivera (09-11020) 
		& José Julián Prado (09-11006)
		& Grupo 9 Taller de Lenguajes de Programación I (CI-3661) 
		Entrega: Proyecto # 2
		 
  conteniendo el codigo fuente Haskell para el programa principal
-}

import qualified System.Directory as D
import qualified System.Environment as SE (getArgs)
import qualified Control.Concurrent as CC
import qualified Data.Map as DM
import qualified System.IO as SIO 
import qualified Data.List as DL
import qualified Graphics.HGL as G
import qualified Data.Maybe as M
import Pixels
import Effects

mensajeLC = "\nError: Deben haber al menos dos archivos en la linea de comandos\n"
mensajeNE = "\nError: El archivo "
mensajeNe = " no existe"
ppc = 12

main = do
  archivos <- SE.getArgs

  if DL.length archivos < 2 
    then error mensajeLC --Caso error en la linea de comandos
	
    else do fileExists <- D.doesFileExist (DL.head archivos)
	    if fileExists 
	       then do fontEntrada1 <- SIO.openFile (DL.head archivos) SIO.ReadMode
		       x <- readFont fontEntrada1
		       y <- procesarArchivos (DL.tail archivos) []
		       ledDisplay x y
	       else error (mensajeNE++"\""++DL.head archivos++"\""++mensajeNe)
	       
	       
-- | Permite mostrar los @Effects@ en la ventana
ledDisplay :: DM.Map Char Pixels -> [Effects] -> IO ()
ledDisplay x y =
  G.runGraphics $ do
    w <- G.openWindowEx
	  "Pixels"
	  (Just (10,10))
	  (300,300)
	  G.DoubleBuffered
	  (Just 50)

    dale x y (Pixels G.White [[]]) w
	     
      where
	 isKey :: G.Event -> Bool
	 isKey (G.Key _ _ ) = True
	 isKey _ = False

	 foo :: G.Window -> IO() -> IO ()
	 foo w f = do
	   e <- G.maybeGetWindowEvent w
	   let k = M.fromJust e
	   if (M.isNothing e) then do
	     f 
	     else if (isKey k) then do
		    G.closeWindow w
		    else do
		    f
	 dale :: DM.Map Char Pixels -> [Effects] -> Pixels -> G.Window -> IO ()
	 dale _ [] _ w = do
	   g<-G.getKey w
	   G.closeWindow w
	 dale m (Say a:xs) _ w = do
           G.getWindowTick w
	   G.closeWindow w
	   w <- G.openWindowEx
		 "Pixels"
		 (Just (10,10))
		 (y*ppc, x*ppc)
		 G.DoubleBuffered
		 (Just 50)

	   G.setGraphic w $ dibujarPixels q
--	   foo w $ dale m xs q w
           dale m xs q w
	   where q = messageToPixels m a
		 x = length $ dots q
		 y = length $ head $ dots q
	 dale m (Up:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ up p
--           foo w $ dale m xs (up p) w
           dale m xs (up p) w
	 dale m (Down:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ down p
--	   foo w $ dale m xs (down p) w
           dale m xs (down p) w
	 dale m (Effects.Left:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ left p
--	   foo w $ dale m xs (left p) w
           dale m xs (left p) w
	 dale m (Effects.Right:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ right p
--	   foo w $ dale m xs (right p) w
           dale m xs (right p) w
	 dale m (Backwards:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ backwards p
--	   foo w $ dale m xs (backwards p) w
           dale m xs (backwards p) w
	 dale m (UpsideDown:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ upsideDown p
--	   foo w $ dale m xs (upsideDown p) w
           dale m xs (upsideDown p) w
	 dale m (Negative:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ negative p
--	   foo w $ dale m xs (negative p) w
           dale m xs (negative p) w
	 dale m (Delay i:xs) p w = do
           G.getWindowTick w
	   CC.threadDelay $ fromIntegral i
--	   foo w $ dale m xs p w
           dale m xs p w
	 dale m (Color c:xs) p w = do
           G.getWindowTick w
	   G.setGraphic w $ dibujarPixels $ changeColor p c
--	   foo w $ dale m xs (changeColor p c) w
           dale m xs (changeColor p c) w
	 dale m (Forever e:xs) p w = do
           G.getWindowTick w
--	   foo w $ dale m (concat (forever e)) p w
           dale m (e++[Forever e]) p w
	     where forever e = e : forever e	     
	 dale m ((Repeat i e):xs) p w = do
           G.getWindowTick w
--	   foo w $ dale m ((replicar e i)++xs) p w
           dale m ((replicar e i)++xs) p w
	     where 
	       replicar e i = concat $ replicate (fromIntegral i) e  

-- | Procesa todos los archivos y retorna una lista con todos los efectos
procesarArchivos :: [FilePath] -> [Effects] -> IO [Effects]
procesarArchivos []  n	  = return n
procesarArchivos (x:xs) n = do fileExists <- D.doesFileExist (x)
			       if fileExists 
				then do effects1 <- SIO.openFile (x) SIO.ReadMode
					y <- readDisplayInfo effects1
					procesarArchivos xs (n++y)
				else error (mensajeNE++"\""++ x ++"\""++mensajeNe)
