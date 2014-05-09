 {-| 
  Module      : Pixels
  Copyright   : Universidad Simón Bolívar
  Maintainer  : Luiscarlo Rivera (09-11020) 
                & José Julián Prado (09-11006)
                & Grupo 9 Taller de Lenguajes de Programación I (CI-3661) 
                Entrega: Proyecto # 2
                 
  Módulo que genera Pixels Display de caracteres de la tabla ASCII
-}
module Pixels where
-- (
--   -- * Tipos 
--  Pixels(color, dots), Pixel(on), Posicion, Pantalla, 
--  
--  -- * Tipografia
--  font,
--  
--  -- * Manipulación Graficas
--  changeColor, hacerPantalla, dibujarPixels, 
--  pixelListToCoord, oldPixelsToPixels, 
--  
--  -- * Combinadores
--  pixelListToPixels, concatPixels, messageToPixels,
--    
--   -- * Efectos especiales 
--   up, down, left, right, upsideDown, backwards, negative, readFont 
-- )where

import qualified Data.Char as DC
import qualified System.IO as SIO 
import qualified Data.Map as DM
import qualified Graphics.HGL as G
import qualified Data.Maybe as M
import qualified Data.List as DL


-- | ´color´ Representa el color del Pixels
-- | ´dots´  Conjunto de puntos que son la representacion del Pixels
data Pixels = Pixels { color :: G.Color, dots ::[[Pixel]] } deriving Show

data Pixel = Pixel { on :: Bool } deriving (Show) -- |´on´ Representa si el Pixel esta encendido o apagado

--altura = 64
--anchura = 64
ppc = 8

-- | Tupla de @Int@ que representan las coordenadas @X@ y @Y@ de un Pixel
type Posicion = (Int, Int)

-- | Lista de tuplas
type Pantalla = [Posicion]


-- | Crea un @Pixels@ a partir de un carácter imprimible que se encuentre en el
-- mapa de bits
font :: DM.Map Char Pixels -> Char -> Pixels
font m c = pix $ DM.lookup c m
           where 
             pix may = if M.isJust may then M.fromJust may
                           else allOn $ snd $ DM.elemAt 0 m

             --enciende todos los Pixel 
             allOn :: Pixels -> Pixels
             allOn (Pixels w p) = Pixels w $ map (\ p1 -> map turnOn p1) $  p

             --cambia el valor del Pixel a True
             turnOn :: Pixel -> Pixel
             turnOn p = Pixel True

-- | Cambia el color de los @dots@ del Pixels
changeColor :: Pixels -> G.Color -> Pixels
changeColor (Pixels _ p) c = Pixels c p
                                   

-- | Recibe el conjunto de puntos Pixel y genera las posiciones donde estaran
hacerPantalla :: [[Pixel]] -> Pantalla
hacerPantalla [] = []
hacerPantalla x = doit x 0 []
                  where doit [] _ p = p
                        doit (y:ys) n p = doit ys (n+1) $ p ++ pixelListToCoord y n 

-- | Convierte un @Pixels@ en un comando grafico para dibujar
dibujarPixels ::Pixels -> G.Graphic
dibujarPixels p = G.overGraphics $ map (dibujarPixel (color p)) $ hacerPantalla $ dots p
  where 
    -- | Convierte un Pixel en un comando grafico para dibujar
    dibujarPixel :: G.Color -> Posicion -> G.Graphic
    dibujarPixel c (x,y) = G.withColor c $
                        G.ellipse (x*ppc+1,y*ppc+1) (((x+1))*ppc,(y+1)*ppc)
                     

-- | Convierte una lista de @Pixel@ en una lista de tuplas
pixelListToCoord :: [Pixel]-> Int -> Pantalla
pixelListToCoord [] _ = []
pixelListToCoord l n = hazlo l n 0 []
                       where hazlo [] _ _ f = f
                             hazlo (x:xs) k m f = if (on x) then hazlo xs k (m+1) ((m,k):f)  else hazlo xs k (m+1) f

-- | Convierte una lista de @String@ formado de @' '@ y @ '*'@
-- en su representacion en pixels
oldPixelsToPixels :: [String] -> Pixels
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
                  where zipWith' f a b = if null (head b) then a else zipWith (f) a b

-- | Convierte un @String@ a @Pixels@ agregando un
-- espacio en blanco entre cada carácter de la entrada
messageToPixels :: DM.Map Char Pixels -> String -> Pixels
messageToPixels m s = concatPixels $ map (font m) $ s


-- | Desplaza una hilera de un @Pixels@ hacia arriba
up :: Pixels -> Pixels
up (Pixels c (x:xs)) = Pixels c $ xs ++ [x]


-- | Desplaza una hilera de un @Pixels@ hacia abajo
down :: Pixels -> Pixels
down (Pixels c a) = Pixels c $ last a : init a


-- | Desplaza una columna de @Pixels@ hacia la izquierda
left :: Pixels -> Pixels
left (Pixels c a) = Pixels c $ map (\ (x:xs) -> xs ++ [x]) a


-- | Desplaza una columna de @Pixels@ hacia la derecha
right :: Pixels -> Pixels
right (Pixels c a) = Pixels c $ map (\ l -> last l : init l) a


-- | Invierte el orden de las filas de un @Pixels@ 
upsideDown :: Pixels -> Pixels
upsideDown (Pixels c a) = Pixels c $ reverse a


-- | Invierte el orden de las columnas de un @Pixels@    
backwards :: Pixels -> Pixels
backwards (Pixels c a) = Pixels c $ map reverse a


-- | Intercambia los @' '@ por @'*'@ en un @Pixels@ y viceversa
negative :: Pixels -> Pixels
negative (Pixels c a) = Pixels c $ map (\ l -> map (\ (Pixel p) -> Pixel (not p)) l ) a


-- |Permite obtener la representacion en pixels de los caracteres
-- particulares del alfabeto a partir de un archivo
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
    validarUnicidad cont = all (\(x,_)-> (DL.length x) == 1) cont
                                      
    --valida que el tamaño que representa los pixeles se corresponda
    validarTam :: Int -> Int -> [(t, [[a]])] -> Bool
    validarTam fil colm cont =  all (\(_,x)-> (length x == fil) && (all (\w -> (length w == colm)) x) ) cont

    --obtengo los numeros que traen en el archivo Y valido que no vengan cosas tipo a1... pero se escapan --1
    obtenerNumeros :: String -> [Int]
    obtenerNumeros w = if all (\x -> all (\y-> DC.isDigit y || y == '-') x)(words w)
                      then (map (\x -> read x::Int) (words w))
                      else error "Numero no validos"

    -- procesa el font
    obtenerTuplas :: Int -> [[Char]] -> [([Char], ([[Char]], [[Char]]))]
    obtenerTuplas _   [] = []
    obtenerTuplas num ls = ((eliminarEspeciales(DL.head ls)),DL.splitAt num (DL.tail (take (num+1) ls)) ) : obtenerTuplas num (DL.dropWhile DL.null (DL.drop (num+1) ls) )
            
    --eliminino los \" que vienen del archivo
    eliminarEspeciales :: [Char] -> [Char]
    eliminarEspeciales w = (DL.delete  '\"' (DL.delete  '\"' w))

    --remueve caracteres de control
    remCont :: [([Char], [[Char]])] -> [([Char], [[Char]])]
    remCont w = map (\(x,y)-> ((removerControl x), (map (removerControl) y))) w
      where
        removerControl :: [Char] -> [Char]
        removerControl [] = []
        removerControl (x:xs) = if DC.isControl x 
                            then removerControl (xs) 
                            else x:removerControl(xs) 
