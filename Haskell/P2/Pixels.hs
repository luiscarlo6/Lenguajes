module Pixels where

import qualified Data.Char as DC
import qualified System.IO as SIO 
import qualified Data.Map as DM
import qualified Graphics.HGL as G
import qualified Data.Maybe as M
import qualified Data.List as DL

data Pixels = Pixels { color :: G.Color, dots ::[[Pixel]] } deriving Show

data Pixel = Pixel { on :: Bool } deriving (Show)

altura = 64
anchura = 64
ppc = 8 

type Posicion = (Int, Int)
type Pantalla = [Posicion]

font :: DM.Map Char Pixels -> Char -> Pixels
font m c = pix $ DM.lookup c m
           where pix may = if M.isJust may then M.fromJust may
                           else allOn $ snd $ DM.elemAt 0 m

allOn :: Pixels -> Pixels
allOn (Pixels c p) = Pixels c $ map (\ p1 -> map turnOn p1) $  p

turnOn :: Pixel -> Pixel
turnOn p = Pixel True

changeColor :: Pixels -> G.Color -> Pixels
changeColor (Pixels _ p) c = Pixels c p
                                   
hacerPantalla :: [[Pixel]] -> Pantalla
hacerPantalla [] = []
hacerPantalla x = doit x 0 []
                  where doit [] _ p = p
                        doit (x:xs) n p = doit xs (n+1) $ p ++ pixelListToCoord x n 

dibujarPixels ::Pixels -> G.Graphic
dibujarPixels p = G.overGraphics $ map (dibujarPixel (color p)) $ hacerPantalla $ dots p

dibujarPixel :: G.Color -> Posicion -> G.Graphic
dibujarPixel c (x,y) = G.withColor c $
                     G.ellipse (x*ppc+1,y*ppc+1) (((x+1))*ppc,(y+1)*ppc)
                     
repeatFunc :: Int -> (Pixels -> Pixels) -> Pixels ->Pixels
repeatFunc i f p = concatPixels $ replicate i  $ (f p)

pixelListToCoord :: [Pixel]-> Int -> Pantalla
pixelListToCoord [] _ = []
pixelListToCoord l n = hazlo l n 0 []
                       where hazlo [] _ _ f = f
                             hazlo (x:xs) n m f = if (on x) then hazlo xs n (m+1) ((m,n):f)  else hazlo xs n (m+1) f


oldPixelsToPixels :: [String] -> Pixels
--oldPixelsToPixels s = Pixels G.White $ map (\st -> map (\x -> if x ==' ' then Pixel False else Pixel True) st) s
oldPixelsToPixels s = Pixels G.Blue $ map (\st -> map (\x -> Pixel (x=='*')) st) s


-- | Convierte una lista de @Pixels@ en un valor de @Pixels@ 
-- que lo represente con un @String@ vacío entre ambos
pixelListToPixels :: [Pixels]->Pixels
pixelListToPixels lp = foldr (\p1 p2 -> Pixels G.White (dots p1 ++ [[]] ++dots p2)) (Pixels G.White [[]]) lp

-- | Convierte una lista de @Pixels@ en un solo valor
-- de @Pixels@ concatenando de forma horizontal y sin 
-- espacios entre cada @Pixels@ de la entrada
concatPixels :: [Pixels] -> Pixels
concatPixels lp = foldr (\ p1 p2 -> Pixels G.White (zipWith' (++) (dots p1) (dots p2))) (Pixels G.White [[]]) lp
                  where zipWith' f a b = if null (head b) then a else zipWith (++) a b

-- | Convierte un @String@ a @Pixels@ agregando un
-- espacio en blanco entre cada carácter de la entrada
messageToPixels :: DM.Map Char Pixels -> String -> Pixels
--messageToPixels m s = intercalar $ concatPixels $ map (font m) $ s
--messageToPixels m s = concatPixels $ map (font m) $ DL.intersperse ' ' s
messageToPixels m s = concatPixels $ map (font m) $ s

intercalar (Pixels c s) = Pixels c $ map (DL.intersperse (Pixel False)) s

-- | Desplaza una hilera de un @Pixels@ hacia arriba
up :: Pixels -> Pixels
up (Pixels c (x:xs)) = Pixels c $ xs ++ [x]
--up p = Pixels (color p) $ arriba $ dots p where arriba (x:xs) = xs ++ [x]

-- | Desplaza una hilera de un @Pixels@ hacia abajo
down :: Pixels -> Pixels
down (Pixels c a) = Pixels c $ last a : init a
--down p = Pixels (color p) $ abajo $ dots p where abajo a = last a : init a

-- | Desplaza una columna de @Pixels@ hacia la izquierda
left :: Pixels -> Pixels
left (Pixels c a) = Pixels c $ map (\ (x:xs) -> xs ++ [x]) a
--left p = Pixels (color p) $ map (\ (x:xs) -> xs ++ [x]) $ dots p

-- | Desplaza una columna de @Pixels@ hacia la derecha
right :: Pixels -> Pixels
right (Pixels c a) = Pixels c $ map (\ l -> last l : init l) a
--right p = Pixels (color p) $ map (\ l ->last l : init l) $ dots p

-- | Invierte el orden de las filas de un @Pixels@ 
upsideDown :: Pixels -> Pixels
upsideDown (Pixels c a) = Pixels c $ reverse a
--upsideDown p = Pixels (color p) $ reverse $ dots p

-- | Invierte el orden de las columnas de un @Pixels@    
backwards :: Pixels -> Pixels
backwards (Pixels c a) = Pixels c $ map reverse a
--backwards p = Pixels (color p) $ map reverse (dots p)

-- | Intercambia los @' '@ por @'*'@ en un @Pixels@ y viceversa
negative :: Pixels -> Pixels
negative (Pixels c a) = Pixels c $ map (\ l -> map (\ (Pixel p) -> Pixel (not p)) l ) a

readFont :: SIO.Handle -> IO (DM.Map Char Pixels)
readFont n = do fontEntrada <- SIO.hGetContents n
                     --caso archivo font vacio
                if DL.null fontEntrada 
                    then error mensajeAV
                    
                    else do let numeros = obtenerNumeros (DL.head (DL.lines fontEntrada)) 
                            --valido que todos los numeros sean positivos
                            if not (DL.all (>=0) numeros)
                              then error mensajeNN
                              
                              else do let contenidoFont =remCont (map (\(x,y)->(x,fst y))(obtenerTuplas (last numeros ) ( dropWhile null $ tail $ lines fontEntrada )))
                                      --valida que los tamaños se correspondan
                                      if not (validarTam (last numeros) (head numeros) contenidoFont ) 
                                          then do print contenidoFont
                                                  error mensajeNC
                                          --valida que los string tengan un solo caracter
                                          else if not (validarUnicidad contenidoFont) 
                                              then error mensajeMC
                                              else do let final = map (\(x,y)-> ((head x),y)) contenidoFont
                                                      return (DM.fromList(map (\(x,y)-> (x,(oldPixelsToPixels y)))final))
  where
    --mensajes de errores
    mensajeAV = "\nError: El archivo font esta vacio\n"
    mensajeNN = "\nError: Los numeros suministrados en el archivo deben de ser positivos\n"
    mensajeNC = "\nError: Los tamaños de filas y columnas no corresponden\n"
    mensajeMC = "\nError: Hay un caracter mas entre comillas\n"

    --Valida que halla exactamente un caracter entre comillas
    validarUnicidad :: [([a], t)] -> Bool
    validarUnicidad cont = all (\(x,y)-> (DL.length x) == 1) cont
                                      
    --valida que el tamaño que representa los pixeles se corresponda
    validarTam :: Int -> Int -> [(t, [[a]])] -> Bool
    validarTam fil colm cont =  all (\(w,x)-> (length x == fil) && (all (\w -> (length w == colm)) x) ) cont

    --obtengo los numeros que traen en el archivo Y valido que no vengan cosas tipo a1... pero se escapan --1
    obtenerNumeros :: String -> [Int]
    obtenerNumeros n = if all (\x -> all (\y-> DC.isDigit y || y == '-') x)(words n)
                      then (map (\x -> read x::Int) (words n))
                      else error "Numero no validos"

    -- procesa el font
    obtenerTuplas :: Int -> [[Char]] -> [([Char], ([[Char]], [[Char]]))]
    obtenerTuplas num [] = []
    obtenerTuplas num ls = ((eliminarEspeciales(DL.head ls)),DL.splitAt num (DL.tail (take (num+1) ls)) ) : obtenerTuplas num (DL.dropWhile DL.null (DL.drop (num+1) ls) )
            
    --eliminino los \" que vienen del archivo
    eliminarEspeciales :: [Char] -> [Char]
    eliminarEspeciales n = (DL.delete  '\"' (DL.delete  '\"' n))

    --remueve caracteres de control
    remCont :: [([Char], [[Char]])] -> [([Char], [[Char]])]
    remCont n = map (\(x,y)-> ((removerControl x), (map (removerControl) y))) n
      where
        removerControl :: [Char] -> [Char]
        removerControl [] = []
        removerControl (x:xs) = if DC.isControl x 
                            then removerControl (xs) 
                            else x:removerControl(xs) 
