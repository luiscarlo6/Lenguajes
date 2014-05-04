import qualified Data.Map as DM
import qualified Graphics.HGL as G
import qualified Data.Maybe as M

data Pixels = Pixels { color :: G.Color, dots ::[[Pixel]] } deriving Show

data Pixel = Pixel { on :: Bool } deriving (Show)

font :: DM.Map Char Pixels -> Char -> Pixels
font m c = pix $ DM.lookup c m
          where pix may = if M.isJust may then M.fromJust may
                          else Pixels G.White [[]]

oldPixelsToPixels :: [String] -> Pixels
oldPixelsToPixels s = Pixels G.White $ map (\st -> map (\x -> if x ==' ' then Pixel False else Pixel True) st) s


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


--variables de uso 
a = oldPixelsToPixels [" *** ","*   *","*   *","*   *","*****","*   *","*   *"]
b = oldPixelsToPixels ["**** ","*   *","*   *","**** ","*   *","*   *","**** "]
c = [a,b]

