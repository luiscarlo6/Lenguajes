import qualified Data.List as DL
import qualified Data.Char as DC
import qualified System.Environment as SE (getArgs)
import qualified System.IO as SIO 
import qualified Data.Map as DM
import Pixels

mensajeLC = "\nError: Deben haber al menos dos archivos en la linea de comandos\n"


main = do
  archivos <- SE.getArgs

  if DL.length archivos < 2 
    then error mensajeLC --Caso error en la linea de comandos
        
    else do fontEntrada1 <- SIO.openFile (DL.head archivos) SIO.ReadMode
            x <- readFont fontEntrada1
            print ( x)
            --print "\n"


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