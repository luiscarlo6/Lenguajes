import qualified Data.Map as DM
import qualified Graphics.HGL as G
import qualified Data.Maybe as M
import qualified Data.List as DL

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
