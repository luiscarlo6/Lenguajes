module Pixels where

import qualified Data.Char as DC
import qualified System.IO as SIO 

import qualified Data.Map as DM
import qualified Graphics.HGL as G
import qualified Data.Maybe as M
import qualified Data.List as DL
import qualified System.IO as SIO

data Pixels = Pixels { color :: G.Color, dots ::[[Pixel]] } deriving Show

data Pixel = Pixel { on :: Bool } deriving (Show)

font :: DM.Map Char Pixels -> Char -> Pixels
font m c = pix $ DM.lookup c m
          where pix may = if M.isJust may then M.fromJust may
                          else Pixels G.White [[]]

oldPixelsToPixels :: [String] -> Pixels
--oldPixelsToPixels s = Pixels G.White $ map (\st -> map (\x -> if x ==' ' then Pixel False else Pixel True) st) s
oldPixelsToPixels s = Pixels G.White $ map (\st -> map (\x -> Pixel (x=='*')) st) s


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
messageToPixels m s = concatPixels $ map (font m) $ DL.intersperse ' ' s

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

-- readFont :: Handle -> IO (Map Char Pixels)
-- readFont :: SIO.Handle -> IO Int
-- readFont h = do f <- SIO.hGetContents h
--                 let x = lines f
--                 let col = read $ (words (head x)) !! 1
--                 return col
-- main = do 
--           let file = "alfabeto"
--           h <- SIO.openFile file SIO.ReadMode 
          n <- readFont h

--______________________________________________________________________________

--mensajeLC = "\nError: Deben haber al menos dos archivos en la linea de comandos\n"
mensajeAV = "\nError: El archivo font esta vacio\n"
mensajeNN = "\nError: Los numeros suministrados en el archivo deben de ser positivos\n"
mensajeNC = "\nError: Los tamaños de filas y columnas no corresponden\n"
mensajeMC = "\nError: Hay un caracter mas entre comillas\n"



readFont :: SIO.Handle -> IO (DM.Map Char Pixels)
readFont n = do fontEntrada <- SIO.hGetContents n
                --let alicia = temporal (fontEntrada)
                    --beth = map (\(x,y)-> ((stringToChar x),y)) alicia
                    --caso archivo font vacio
                if DL.null fontEntrada 
                    then error mensajeAV
                    
                    else do let numeros = obtenerNumeros (DL.head (DL.lines fontEntrada)) 
                            
                            if not (DL.all (>0) numeros)
                              then error mensajeNN
                              
                              else do let contenidoFont = temporal(fontEntrada)
                                          --print numeros
                                          --print contenidoFont
                                      if not (validarTamaños (fromEnum(last numeros)) (fromEnum(head numeros)) contenidoFont ) 
                                          then error mensajeNC
                                          else if not (validarUnicidad contenidoFont) 
                                              then error mensajeMC
                                              else do let final = map (\(x,y)-> ((stringToChar x),y)) contenidoFont
                                                      --return (M.fromList final)
                                                      return (DM.fromList(map (\(x,y)-> (x,(oldPixelsToPixels y)))final))
                                                              

                
                
                
                
                
                
                
                
                
                
validarUnicidad cont = all (\(x,y)-> (DL.length x) == 1) cont
                                  
                                  
--valida que el tamaño que representa los pixeles se corresponda
validarTamaños fil colm cont =  all (\(w,x)-> (length x == fil) && (all (\w -> (length w == colm)) x) ) cont


--obtengo los numeros que traen en el archivo
obtenerNumeros n = map stringToInt (words n)

--se le pasa el archivo font leido y lo procesa
temporal n = map (\(x,y)->(x,fst y))(procesar (read (last (words (head (lines n ))))::Int) ((dropWhile null $ tail $ lines n )))

-- procesa el font
procesar num [] = []
procesar num ls = ((eliminarEspeciales(DL.head b)),DL.splitAt num (DL.tail b) ) : procesar num (DL.dropWhile DL.null bs)
  where (b,bs) = DL.break null ls
        

        
eliminarEspeciales n = (DL.delete  '\"' (DL.delete  '\"' n))--(\(x:_)->x)


stringToChar n = (\(x:_)->x)n




--convertir un string numerico en numero
stringToInt n = if DL.head n == '-' 
                then (-1)*(convertirNum(map (DC.digitToInt) (tail n))) 
                else convertirNum(map (DC.digitToInt) n)
  where
    --Llamo a convertirNumero pero con un solo argumento
    convertirNum n = convertirNumero 0 n

    --convertir una lista de enteros en su numeor equivalente ejemplo [1,0] = 10
    convertirNumero n x = if DL.null x 
                          then n 
                          else convertirNumero (n +(((potenciaDiez ((DL.length x)-1) 1 )*(DL.head x)))) (DL.tail x)

    --Obtengo la n-sima potencia de diez
    potenciaDiez n r = if n == 0 
                      then r 
                      else potenciaDiez (n-1)(r * 10) 
