import qualified Data.List
import qualified Data.Char
import qualified Data.String
import qualified System.Environment as SE (getArgs) 

--palabra = "5 7\n\n\" \"\n     \n     \n     \n     \n     \n     \n     \n\n\"!\"\n  *  \n  *  \n  *  \n  *  \n  *  \n     \n  *  \n\n"

--palabraS = readFile "Prueba"


main = do
  archivos <- SE.getArgs
  --falta chequeo
  fontEntrada <- readFile (head archivos) 
  let prueba = salida (fontEntrada)
  --print fontEntrada
  print prueba





salida n = map (\(x,y)->(x,fst y))(procesar (read (last (words (head (lines n ))))::Int) ((dropWhile null $ tail $ lines n )))



procesar num [] = []
procesar num ls = ((Data.List.head b),Data.List.splitAt num (Data.List.tail b) ) : procesar num (Data.List.dropWhile Data.List.null bs)
  where (b,bs) = Data.List.break null ls
        




        
-- --fila = Data.List.last(stringToInt (Data.List.head (lines palabra)))
-- 
-- --columna = head . stringToInt
-- 
-- --convertir un string numerico en numero
-- stringToInt n = if Data.List.head n == '-' 
--                 then (-1)*(convertirNum(map (Data.Char.digitToInt) (tail n))) 
--                 else convertirNum(map (Data.Char.digitToInt) n)
--   where
--     --Llamo a convertirNumero pero con un solo argumento
--     convertirNum n = convertirNumero 0 n
-- 
--     --convertir una lista de enteros en su numeor equivalente ejemplo [1,0] = 10
--     convertirNumero n x = if Data.List.null x 
--                           then n 
--                           else convertirNumero (n +(((potenciaDiez ((Data.List.length x)-1) 1 )*(Data.List.head x)))) (Data.List.tail x)
-- 
--     --Obtengo la n-sima potencia de diez
--     potenciaDiez n r = if n == 0 
--                        then r 
--                        else potenciaDiez (n-1)(r * 10) 
--                        
--                        

--map (\(x,y)->(x,fst y))(procesar (read (last (words (head (lines palabra ))))::Int) ((dropWhile null $ tail $ lines palabra )))
--map (\(x,y)->(x,fst y))(procesar (read (last (words (head (lines palabra ))))::Int) ((dropWhile null $ tail $ lines palabra )))

-- main = do
--       n <- palabraS
--       x <- salida palabraS
--       print x