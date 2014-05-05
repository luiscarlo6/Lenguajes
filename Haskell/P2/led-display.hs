import qualified Data.List as DL
import qualified Data.Char as DC
import qualified System.Environment as SE (getArgs)



mensajeLC = "\nError: Deben haber al menos dos archivos en la linea de comandos\n"
mensajeAV = "\nError: El archivo font esta vacio\n"
mensajeNN = "\nError: Los numeros suministrados en el archivo deben de ser positivos\n"
mensajeNC = "\nError: Los tamaños de filas y columnas no corresponden\n"

temp = "5 7\n\n\" \"\n     \n     \n     \n     \n     \n     \n     \n\n\"!\"\n  *  \n  *  \n  *  \n  *  \n  *  \n     \n  *  \n\n"

temp1 = ["\" \"","\"!\""]

aux = [5,7]


main = do
  archivos <- SE.getArgs
--   aux <- readFile (head archivos)
--   print aux
  
  
  if DL.length archivos < 2 
    then putStrLn mensajeLC --Caso error en la linea de comandos
         
    else do fontEntrada <- readFile (head archivos) 
            --caso archivo font vacio
            if DL.null fontEntrada 
              then putStrLn mensajeAV
                   
              else do let numeros = obtenerNumeros (DL.head (DL.lines fontEntrada)) 
                                    
                      if not (DL.all (>0) numeros)
                        then putStrLn mensajeNN
                        
                        else do let contenidoFont = readFont(fontEntrada)
                                --print numeros
                                --print contenidoFont
                                if not (validarTamaños (fromEnum(last numeros)) (fromEnum(head numeros)) contenidoFont ) 
                                   then putStrLn mensajeNC
                                   else print contenidoFont


--valida que el tamaño que representa los pixeles se corresponda
validarTamaños fil colm cont =  all (\(w,x)-> (length x == fil) && (all (\w -> (length w == colm)) x) ) cont


--obtengo los numeros que traen en el archivo
obtenerNumeros n = map stringToInt (words n)

--se le pasa el archivo font leido y lo procesa
readFont n = map (\(x,y)->(x,fst y))(procesar (read (last (words (head (lines n ))))::Int) ((dropWhile null $ tail $ lines n )))

-- procesa el font
procesar num [] = []
procesar num ls = ((stringToChar(DL.head b)),DL.splitAt num (DL.tail b) ) : procesar num (DL.dropWhile DL.null bs)
  where (b,bs) = DL.break null ls
        


        

        
        
        
        
stringToChar n = (DL.delete  '\"' (DL.delete  '\"' n))--(\(x:_)->x)







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
