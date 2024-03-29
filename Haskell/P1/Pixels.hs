{-| 
  Module      : Pixels
  Copyright   : Universidad Simón Bolívar
  Maintainer  : Luiscarlo Rivera (09-11020) 
                & José Julián Prado (09-11006)
                & Grupo 9 Taller de Lenguajes de Programación I (CI-3661) 
                Entrega: Proyecto # 1
                 
  Módulo que genera Pixels Display de todos los caracteres imprimibles de la
  tabla ASCII
-}
module Pixels (
  -- * Tipo @Pixels@
  Pixels, 
  
  -- * Tipografía desde mapa de bits
  font, 
  
  -- * Mostrar @Pixels@ en pantalla
  pixelsToString, pixelListToPixels, pixelListToString, 
  
  -- * Combinadores
  concatPixels, messageToPixels, 
  
  -- * Efectos especiales 
  up, down, left, right, upsideDown, 
  backwards, negative 
  
  ) where


import Data.Bits
import Data.Char
import Data.List

-- | Una lista de @String@ donde cada carácter representa un led de un @Display@
type Pixels = [String]

-- | Crea un @Pixels@ a partir de un carácter imprimible de la tabla ASCII
font :: Char -> Pixels
font a = 
  let
    -- | Mapa de bits de carácteres imprimibles de la tabla ASCII
    fontBitmap =
      [
        [ 0x00, 0x00, 0x00, 0x00, 0x00 ], --  (space)
        [ 0x00, 0x00, 0x5F, 0x00, 0x00 ], --  !
        [ 0x00, 0x07, 0x00, 0x07, 0x00 ], --  "
        [ 0x14, 0x7F, 0x14, 0x7F, 0x14 ], --  #
        [ 0x24, 0x2A, 0x7F, 0x2A, 0x12 ], --  $
        [ 0x23, 0x13, 0x08, 0x64, 0x62 ], --  %
        [ 0x36, 0x49, 0x55, 0x22, 0x50 ], --  &
        [ 0x00, 0x05, 0x03, 0x00, 0x00 ], --  '
        [ 0x00, 0x1C, 0x22, 0x41, 0x00 ], --  (
        [ 0x00, 0x41, 0x22, 0x1C, 0x00 ], --  )
        [ 0x08, 0x2A, 0x1C, 0x2A, 0x08 ], --  *
        [ 0x08, 0x08, 0x3E, 0x08, 0x08 ], --  +
        [ 0x00, 0x50, 0x30, 0x00, 0x00 ], --  ,
        [ 0x08, 0x08, 0x08, 0x08, 0x08 ], --  -
        [ 0x00, 0x60, 0x60, 0x00, 0x00 ], --  .
        [ 0x20, 0x10, 0x08, 0x04, 0x02 ], --  /
        [ 0x3E, 0x51, 0x49, 0x45, 0x3E ], --  0
        [ 0x00, 0x42, 0x7F, 0x40, 0x00 ], --  1
        [ 0x42, 0x61, 0x51, 0x49, 0x46 ], --  2
        [ 0x21, 0x41, 0x45, 0x4B, 0x31 ], --  3
        [ 0x18, 0x14, 0x12, 0x7F, 0x10 ], --  4
        [ 0x27, 0x45, 0x45, 0x45, 0x39 ], --  5
        [ 0x3C, 0x4A, 0x49, 0x49, 0x30 ], --  6
        [ 0x01, 0x71, 0x09, 0x05, 0x03 ], --  7
        [ 0x36, 0x49, 0x49, 0x49, 0x36 ], --  8
        [ 0x06, 0x49, 0x49, 0x29, 0x1E ], --  9
        [ 0x00, 0x36, 0x36, 0x00, 0x00 ], --  :
        [ 0x00, 0x56, 0x36, 0x00, 0x00 ], --  ;
        [ 0x00, 0x08, 0x14, 0x22, 0x41 ], --  <
        [ 0x14, 0x14, 0x14, 0x14, 0x14 ], --  =
        [ 0x41, 0x22, 0x14, 0x08, 0x00 ], --  >
        [ 0x02, 0x01, 0x51, 0x09, 0x06 ], --  ?
        [ 0x32, 0x49, 0x79, 0x41, 0x3E ], --  @
        [ 0x7E, 0x11, 0x11, 0x11, 0x7E ], --  A
        [ 0x7F, 0x49, 0x49, 0x49, 0x36 ], --  B
        [ 0x3E, 0x41, 0x41, 0x41, 0x22 ], --  C
        [ 0x7F, 0x41, 0x41, 0x22, 0x1C ], --  D
        [ 0x7F, 0x49, 0x49, 0x49, 0x41 ], --  E
        [ 0x7F, 0x09, 0x09, 0x01, 0x01 ], --  F
        [ 0x3E, 0x41, 0x41, 0x51, 0x32 ], --  G
        [ 0x7F, 0x08, 0x08, 0x08, 0x7F ], --  H
        [ 0x00, 0x41, 0x7F, 0x41, 0x00 ], --  I
        [ 0x20, 0x40, 0x41, 0x3F, 0x01 ], --  J
        [ 0x7F, 0x08, 0x14, 0x22, 0x41 ], --  K
        [ 0x7F, 0x40, 0x40, 0x40, 0x40 ], --  L
        [ 0x7F, 0x02, 0x04, 0x02, 0x7F ], --  M
        [ 0x7F, 0x04, 0x08, 0x10, 0x7F ], --  N
        [ 0x3E, 0x41, 0x41, 0x41, 0x3E ], --  O
        [ 0x7F, 0x09, 0x09, 0x09, 0x06 ], --  P
        [ 0x3E, 0x41, 0x51, 0x21, 0x5E ], --  Q
        [ 0x7F, 0x09, 0x19, 0x29, 0x46 ], --  R
        [ 0x46, 0x49, 0x49, 0x49, 0x31 ], --  S
        [ 0x01, 0x01, 0x7F, 0x01, 0x01 ], --  T
        [ 0x3F, 0x40, 0x40, 0x40, 0x3F ], --  U
        [ 0x1F, 0x20, 0x40, 0x20, 0x1F ], --  V
        [ 0x7F, 0x20, 0x18, 0x20, 0x7F ], --  W
        [ 0x63, 0x14, 0x08, 0x14, 0x63 ], --  X
        [ 0x03, 0x04, 0x78, 0x04, 0x03 ], --  Y
        [ 0x61, 0x51, 0x49, 0x45, 0x43 ], --  Z
        [ 0x00, 0x00, 0x7F, 0x41, 0x41 ], --  [
        [ 0x02, 0x04, 0x08, 0x10, 0x20 ], --  \
        [ 0x41, 0x41, 0x7F, 0x00, 0x00 ], --  ]
        [ 0x04, 0x02, 0x01, 0x02, 0x04 ], --  ^
        [ 0x40, 0x40, 0x40, 0x40, 0x40 ], --  _
        [ 0x00, 0x01, 0x02, 0x04, 0x00 ], --  `
        [ 0x20, 0x54, 0x54, 0x54, 0x78 ], --  a
        [ 0x7F, 0x48, 0x44, 0x44, 0x38 ], --  b
        [ 0x38, 0x44, 0x44, 0x44, 0x20 ], --  c
        [ 0x38, 0x44, 0x44, 0x48, 0x7F ], --  d
        [ 0x38, 0x54, 0x54, 0x54, 0x18 ], --  e
        [ 0x08, 0x7E, 0x09, 0x01, 0x02 ], --  f
        [ 0x08, 0x14, 0x54, 0x54, 0x3C ], --  g
        [ 0x7F, 0x08, 0x04, 0x04, 0x78 ], --  h
        [ 0x00, 0x44, 0x7D, 0x40, 0x00 ], --  i
        [ 0x20, 0x40, 0x44, 0x3D, 0x00 ], --  j
        [ 0x00, 0x7F, 0x10, 0x28, 0x44 ], --  k
        [ 0x00, 0x41, 0x7F, 0x40, 0x00 ], --  l
        [ 0x7C, 0x04, 0x18, 0x04, 0x78 ], --  m
        [ 0x7C, 0x08, 0x04, 0x04, 0x78 ], --  n
        [ 0x38, 0x44, 0x44, 0x44, 0x38 ], --  o
        [ 0x7C, 0x14, 0x14, 0x14, 0x08 ], --  p
        [ 0x08, 0x14, 0x14, 0x18, 0x7C ], --  q
        [ 0x7C, 0x08, 0x04, 0x04, 0x08 ], --  r
        [ 0x48, 0x54, 0x54, 0x54, 0x20 ], --  s
        [ 0x04, 0x3F, 0x44, 0x40, 0x20 ], --  t
        [ 0x3C, 0x40, 0x40, 0x20, 0x7C ], --  u
        [ 0x1C, 0x20, 0x40, 0x20, 0x1C ], --  v
        [ 0x3C, 0x40, 0x30, 0x40, 0x3C ], --  w
        [ 0x44, 0x28, 0x10, 0x28, 0x44 ], --  x
        [ 0x0C, 0x50, 0x50, 0x50, 0x3C ], --  y
        [ 0x44, 0x64, 0x54, 0x4C, 0x44 ], --  z
        [ 0x00, 0x08, 0x36, 0x41, 0x00 ], --  {
        [ 0x00, 0x00, 0x7F, 0x00, 0x00 ], --  |
        [ 0x00, 0x41, 0x36, 0x08, 0x00 ]  --  }
      ] 
    
    -- | Revisa el bit @n@ del argumento @i@. Si está encendido
    -- retorna @True@, caso contrario retorna @False@
    probarBit :: Int->Int->Char
    probarBit i n = if testBit i n == True then '*' else ' '
    
    -- | Convierte un @Int@ desde su sexto bit mas representativo
    -- a un @String@ de @' '@ y @'*'@ según esten encedidos o apagados
    convertirInt :: Int->String
    convertirInt x = probarBits x 6
    
    -- | Convierte un entero a una cadena de carácteres de 
    -- @'*'@ y @' '@ según sus bits, comenzando por el bit @n@
    probarBits :: Int->Int->String
    probarBits b 0 = probarBit b 0:[]
    probarBits b n = probarBit b n:probarBits b (n-1)
      
    -- |Dado un carácter imprimible en la tabla ASCII, retorna su
    -- representación en el @fontBitmap@
    getFontBit :: Char -> [Int]
    getFontBit y = fontBitmap !! (ord y - 32)
  
  in 
    if 32 <= ord a && ord a <= 125
    then reverse (transpose( map convertirInt (getFontBit a)))
    else reverse (transpose( map convertirInt ([0xFF, 0xFF, 0xFF, 0xFF, 0xFF])))
  
  
        
-- | Convierte un valor del tipo @Pixels@ en un @String@, con saltos
-- de línea en medio de los elementos individuales del @Pixels@
pixelsToString :: Pixels -> String
pixelsToString a = concat (intersperse "\n" a)


-- | Convierte una lista de @Pixels@ en un valor de @Pixels@ 
-- que lo represente con un @String@ vacío entre ambos
pixelListToPixels :: [Pixels]->Pixels
pixelListToPixels a = concat (intersperse [""] a)



-- | Convierte una lista de @Pixels@ en un @String@ con
-- saltos de linea en medio
pixelListToString :: [Pixels]->String
pixelListToString a  = pixelsToString (concat a) 
    
                      

-- | Convierte una lista de @Pixels@ en un solo valor
-- de @Pixels@ concatenando de forma horizontal y sin 
-- espacios entre cada @Pixels@ de la entrada
concatPixels :: [Pixels] -> Pixels
concatPixels [] = []
concatPixels a = foldl1 (zipWith (++)) a 



-- | Convierte un @String@ a @Pixels@ agregando un
-- espacio en blanco entre cada carácter de la entrada
messageToPixels :: String -> Pixels
messageToPixels [] = [] 
messageToPixels a = 
  let
    
    -- | Convierte un @String@ a una lista de @Pixels@
    convertirEnPixels ::String -> [Pixels]
    convertirEnPixels b = map (extenFont) b

    -- | Convierte un @Char@ a @Pixels@ y agrega 
    -- @' '@ al final
    extenFont :: Char -> Pixels
    extenFont x = map (++ " ") (font x)
  in
    map (init) (concatPixels (convertirEnPixels a))


-- | Desplaza una hilera de un @Pixels@ hacia arriba
up :: Pixels -> Pixels
up [] = []
up (x:xs) = xs ++ [x]
 
-- | Desplaza una hilera de un @Pixels@ hacia abajo
down :: Pixels -> Pixels
down a =  last a : init a

  
-- | Desplaza una columna de @Pixels@ hacia la izquierda
left :: Pixels -> Pixels
left a = map moverIzq a
  where 
    
    -- | Mueve a la izquierda un @String@, (Pone de ultimo el primer carácter)
    moverIzq :: String -> String
    moverIzq [] = []
    moverIzq (x:xs) = xs ++ [x]


-- | Desplaza una columna de @Pixels@ hacia la derecha
right :: Pixels -> Pixels
right a =  map reverse (left (map reverse a))



-- | Invierte el orden de las filas de un @Pixels@ 
upsideDown :: Pixels -> Pixels
upsideDown a = reverse a

    
-- | Invierte el orden de las columnas de un @Pixels@    
backwards :: Pixels -> Pixels
backwards a = map reverse a


-- | Intercambia los @' '@ por @'*'@ en un @Pixels@ y viceversa
negative :: Pixels -> Pixels
negative a = map negar a
  where
    
    -- | Cambia @' '@ por @'*'@ y viceversa en un @Char@
    negarBit :: Char -> Char
    negarBit b = if b == '*' 
                 then ' ' 
                 else '*'
    
    -- | Cambia @' '@ por @'*'@ y viceversa en cada elemento de un @String@
    negar :: String -> String
    negar [] = []
    negar s = map negarBit s 
