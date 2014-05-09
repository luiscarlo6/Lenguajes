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
                        
                        

-- | Permite mostrar los @Effects@ en la ventana
ledDisplay :: DM.Map Char Pixels -> [Effects] -> IO ()
ledDisplay x y =
  G.runGraphics $ do
    w <- G.openWindowEx
          "Pixels"
          (Just (100,100))
          (800, 600)
          G.DoubleBuffered
          (Just 50)
          
    dale x y (Pixels G.White [[]]) w
       where
         dale :: DM.Map Char Pixels -> [Effects] -> Pixels -> G.Window -> IO ()
         dale _ [] _ w = do
           G.getWindowTick w
--           G.closeWindow w
         dale m (Say a:xs) _ w = do
           G.setGraphic w $ dibujarPixels $ messageToPixels m a
           dale m xs (messageToPixels m a) w
         dale m (Up:xs) p w = do
           G.setGraphic w $ dibujarPixels $ up p
           dale m xs (up p) w
         dale m (Down:xs) p w = do
           G.setGraphic w $ dibujarPixels $ down p
           dale m xs (down p) w
         dale m (Effects.Left:xs) p w = do
           G.setGraphic w $ dibujarPixels $ left p
           dale m xs (left p) w
         dale m (Effects.Right:xs) p w = do
           G.setGraphic w $ dibujarPixels $ right p
           dale m xs (right p) w
         dale m (Backwards:xs) p w = do
           G.setGraphic w $ dibujarPixels $ backwards p
           dale m xs (backwards p) w
         dale m (UpsideDown:xs) p w = do
           G.setGraphic w $ dibujarPixels $ upsideDown p
           dale m xs (upsideDown p) w
         dale m (Negative:xs) p w = do
           G.setGraphic w $ dibujarPixels $ negative p
           dale m xs (negative p) w
         dale m (Delay i:xs) p w = do
           CC.threadDelay $ fromIntegral i
           dale m xs p w
         dale m (Color c:xs) p w = do
           G.setGraphic w $ dibujarPixels $ changeColor p c
           dale m xs (changeColor p c) w
         dale m (Forever e:xs) p w = do
           dale m (concat (forever e)) p w
             where forever e = e : forever e         
         dale m ((Repeat i e):xs) p w = do           
           dale m ((replicar e i)++xs) p w
             where 
               replicar e i = concat $ replicate (fromIntegral i) e  