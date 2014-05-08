import qualified Data.List as DL
import qualified Data.Char as DC
import qualified System.Environment as SE (getArgs)
import qualified System.IO as SIO 
import qualified Data.Map as DM
import qualified Graphics.HGL as G
import qualified Control.Concurrent as CC
import Pixels
import Effects

mensajeLC = "\nError: Deben haber al menos dos archivos en la linea de comandos\n"

main = do
  archivos <- SE.getArgs

  if DL.length archivos < 2 
    then error mensajeLC --Caso error en la linea de comandos
        
    else do fontEntrada1 <- SIO.openFile (DL.head archivos) SIO.ReadMode
            effects1 <- SIO.openFile (DL.head $ DL.tail archivos) SIO.ReadMode
            x <- readFont fontEntrada1
            y <- readDisplayInfo effects1
			-- procesarArchivos (DL.tail archivos)  x
            ledDisplay x y

ledDisplay :: DM.Map Char Pixels -> [Effects] -> IO ()
ledDisplay x y =
  G.runGraphics $ do
    w <- G.openWindowEx
          "Pixels"
          Nothing
          (800, 600)
          G.DoubleBuffered
          (Just 50)

    dale x y (Pixels G.White [[]]) w
       where
         dale :: DM.Map Char Pixels -> [Effects] -> Pixels -> G.Window -> IO ()
         dale _ [] _ w = do
           G.getWindowTick w
           G.closeWindow w
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
         dale m (Repeat 0 _:xs) p w = do
           dale m xs p w
         dale m (Repeat i e:xs) p w = do
           dale m e p w
           dale m (Repeat (i-1) e:xs) p w
            
           
  

-- procesarArchivos [] x      = putStrLn "Bye!"
-- procesarArchivos (fn:fns) x = do 
--                                   putStrLn $ "Processing " ++ fn
--                                   effects1 <- SIO.openFile (fn) SIO.ReadMode
--                                   y <- readDisplayInfo effects1
--                                   
--                                   
--                                   print y
-- 
--                                   let p =  hacerPantalla $ dots $ font x 'B'
--                                   print p
--                                   let g = map dibujarPixel
--                                   G.runGraphics $ do
--                                   w <- G.openWindowEx
--                                         "Pixels"
--                                         Nothing
--                                         (800, 600)
--                                         G.DoubleBuffered
--                                         (Just 50)
--                                   G.clearWindow w
--                                   
--                                   G.setGraphic w $ G.overGraphics $ map dibujarPixel $ hacerPantalla $ dots $ messageToPixels x "De nada"
--                                   --G.setGraphic w $ dibujarPixel (1,0)
--                                   G.getWindowTick w
--                                   G.getKey w
--                                   G.closeWindow w
--                                   
-- 
--                                   procesarArchivos fns x