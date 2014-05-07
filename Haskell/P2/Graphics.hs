import qualified Graphics.HGL as G

altura  = 128
anchura = 128
ppc     = 3
 
main :: IO ()
main = do
          G.runGraphics $ do
          w <- G.openWindowEx
                 "Pixels"
                 Nothing
                 (ppc*anchura,ppc*altura)
                 G.DoubleBuffered
                 (Just 50)
          G.clearWindow w 
          G.setGraphic w $ G.withColor G.Red $ G.ellipse (6*ppc,6*ppc) (ppc,ppc)
--          G.closeWindow w
