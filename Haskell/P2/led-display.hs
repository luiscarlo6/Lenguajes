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
            effects1 <- SIO.openFile (DL.head $ DL.tail archivos) SIO.ReadMode
            x <- readFont fontEntrada1
            y <- readDisplayInfo effects1
			-- procesarArchivos (DL.tail archivos)  x
            ledDisplay x y






            
           
  

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