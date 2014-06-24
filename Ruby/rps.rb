#!/usr/bin/ruby
# -*- coding: utf-8 -*-

###############################################################################
##############################LOS MOVIMIENTOS##################################
###############################################################################

##
# Clase Movement
# Representa un movimiento ejecutado por un jugador
class Movement
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    self.class.name
  end
end

##
# Clase Rock
# Representa el movimiento Rock
class Rock < Movement
  
  ##
  # Método score
  # Determina el resultado de la jugada entre el invocante y el movimiento m
  # cuando el invocante juega Rock
  def score m
    m.vsroca self
  end
  
  ##
  # Método vsroca
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Rock
  def vsroca m
    [0,0]
  end
  
  ##
  # Método vspapel
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Rock
  def vspapel m
    [1,0]
  end
  
  ##
  # Método vstijera
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Rock
  def vstijera m
    [0,1]
  end
end

##
# Clase Paper
# Representa el movimiento Paper
class Paper < Movement
  
  ##
  # Método score
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Paper
  def score m
    m.vspapel self
  end
  
  ##
  # Método vsroca
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Paper
  def vsroca m
    [0,1]
  end
  
  ##
  # Método vspapel
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Paper
  def vspapel m
    [0,0]
  end
  
  ##
  # Método vstijera
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Paper
  def vstijera m
    [1,0]
  end
end

##
# Clase Scissors
# Representa el movimiento Scissors
class Scissors < Movement
  
  ##
  # Método score
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Scissors
  def score m
    m.vstijera self
  end
  
  ##
  # Método vsroca
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Scissors
  def vsroca m
    [1,0]
  end
  
  ##
  # Método vspapel
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Scissors
  def vspapel m
    [0,1]
  end
  
  ##
  # Método vstijera
  # Determina el resultado de la jugada entre el invocante y el movimiento m,
  # cuando el invocante juega Scissors
  def vstijera m
    [0,0]
  end
end

###############################################################################
################################LAS ESTRATEGIAS################################
###############################################################################

##
# Clase Strategy
# Representa la Estrategia que usara el jugador para realizar sus movimientos
class Strategy
  
  # +SEMILLA+ Valor para inicializar la semilla de la class Random
  SEMILLA = 42
  # +jugador+ Contiene el ID del jugador
  attr_accessor :jugador
  
  ##
  # Método +initialize+
  # Constructor de una Strategy
  # +jug: Id del jugador+
  def initialize jug
    @jugador = jug
  end
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    @jugador.to_s
  end
end

##
# Clase Uniform
# Estrategia donde se elije el siguiente movimiento siguiendo una distribución
# Uniforme
class Uniform < Strategy
  
  # +estrategia+: Contendrá la lista suministrada por el usuario
  # +original+ : Contendrá una copia de dicha lista
  # +contNil+: Variable de control, para saber la cantidad de nil
  attr_accessor :estrategia, :original, :contNil
  
  ##
  # Método +initialize+
  # Constructor de una Estrategia Uniform
  # +lista: lista suministrada por el usuario+
  def initialize lista
    raise ArgumentError, 'La Lista no puede ser vacia' unless (not lista.empty?)
    @estrategia = lista.uniq
    @original = lista.clone.uniq
    @contNil = 0
  end
  
  ##
  # Método next
  # Genera el próximo movimiento posible
  # +m: movimiento del contrincante+
  def next m
    if m==nil
      @contNil +=1
    end
    if @contNil < 2
      temp = @estrategia.first
      @estrategia = @estrategia.rotate
      temp
    end
  end
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    aux = self.class.name + " ["
    @estrategia.each {|x|aux = aux + x.to_s + ", "}
    aux = aux.chomp(", ") + " ]"
  end
  
  ##
  # Método reset
  # Restaura la estrategia a su estado inicial
  def reset
    @estrategia = @original.clone
    @contNil = 0
    self
  end
end

##
# Clase Biased
# Estrategia donde se elije el siguiente movimiento siguiendo una distribución
# Sesgada
class Biased < Strategy
  
  # +estrategia+: Contendrá la lista suministrada por el usuario
  # +original+ : Contendrá una copia de dicha lista
  # +probabilidad+ : Contendrá la suma de todas las probabilidades
  # +contNil+: Variable de control, para saber la cantidad de nil
  attr_accessor :estrategia, :original,:probabilidad, :contNil
  
  ##
  # Método +initialize+
  # Constructor de una Estrategia Biased
  # +mapa: mapa(Hash) suministrado por el usuario+
  def initialize mapa
    raise ArgumentError, 'El mapa no puede ser vacio' unless (not mapa.empty?)
    @estrategia = mapa
    @original = mapa.clone
    cal_prob
    @probabilidad = @estrategia.values.sort
    @contNil = 0
  end
  
  ##
  # Método next
  # Genera el próximo movimiento posible
  # +m: movimiento del contrincante+
  def next m
    if m==nil
      @contNil +=1
    end
    if @contNil < 2
      num = rand()
      arr = @probabilidad.clone
      tam = arr.size
      i = 0
      cInf = 0
      cSup = arr.first
      while i < tam
        if cInf <= num && num < cSup
          return @estrategia.key arr[i]
        end
        arr = arr.rotate
        cInf = cSup
        cSup += arr.first
        i += 1
      end
    end
  end
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    aux = self.class.name + " {"
    @estrategia.each {|key, value| aux = aux + ":#{key} => #{value}, " }
    aux = aux.chomp(", ") + " }"
  end
  
  ##
  # Método reset
  # Restaura la estrategia a su estado inicial
  def reset
    @estrategia = @original.clone
    cal_prob
    @contNil = 0
    self
  end
  
  ##
  # Método Privado cal_prob
  # Calcula las probabilidades asociadas
  private
  def cal_prob
    prob = 0
    @estrategia.values.each {|x| prob = prob + x}
    
    if prob !=0
      @estrategia.each {|key, value| @estrategia[key] = value/prob.to_f}
    end
  end
end

##
# Clase Mirror
# Estrategia donde se elije el siguiente movimiento a partir del ultimo 
# movimiento del contrincante
class Mirror < Strategy
  
  # +estrategia+ : Contendrá la lista suministrada por el usuario
  # +original+   : Contendrá una copia de dicha lista
  # +control+    : Boolean para determinar que jugar en la primera oportunidad
  # +anterior+   : Contendrá el ultimo movimiento del contrincante
  # +contNil+    : Variable de control, para saber la cantidad de nil
  attr_accessor :estrategia, :original, :control, :anterior, :contNil
  
  ##
  # Método +initialize+
  # Constructor de una Estrategia Mirror
  # +mov: movimiento suministrado por el usuario+
  def initialize mov
    @estrategia = mov
    @original = mov.clone
    @control = true
    @anterior = nil
    @contNil = 0
  end
  
  ##
  # Método next
  # Genera el próximo movimiento posible
  # +m: movimiento del contrincante+
  def next m
    if m==nil
      @contNil +=1
    end
    
    if @contNil <2
      if m == nil
        return @estrategia
      end
      
      if @control
        @control = false
        @anterior = m
        @estrategia
      else
        @estrategia = @anterior
        @anterior = m
        @estrategia
      end
    end
  end
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    self.class.name + "  Movimiento Inicial = " + @estrategia.to_s 
  end
  
  ##
  # Método reset
  # Restaura la estrategia a su estado inicial
  def reset
    @estrategia = @original.clone
    @control = true
    @anterior = nil
    @contNil = 0
    self
  end
end

##
# Clase Smart
# Estrategia donde se elije el siguiente movimiento en función de la frecuencia
# de las jugadas realizadas por el usuario
class Smart < Strategy
  
  # +p+       : Cantidad de Paper jugadas por el contrincante
  # +r+       : Cantidad de Rock jugadas por el contrincante
  # +s+       : Cantidad de Scissors jugadas por el contrincante
  # +contNil+ : Variable de control, para saber la cantidad de nil
  attr_accessor :p, :r, :s, :contNil
  
  ##
  # Método +initialize+
  # Constructor de una Estrategia Smart
  def initialize
    @p = 0
    @r = 0
    @s = 0 
    @contNil = 0
    srand(SEMILLA)
  end
  
  ##
  # Método next
  # Genera el próximo movimiento posible
  # +m: movimiento del contrincante+
  def next m
    if m==nil 
      @contNil +=1
    end
    
    if @contNil < 2
      if m==nil
        return Scissors.new
      end
      sumar(m)
      num = rand(@p + @r + @s -1).to_int
      if (0 <= num) && (num < @p)
        Scissors.new
      elsif (@p <= num) && (num < @p+@r)
        Paper.new
      elsif (@p+@r <= num) && (num < @p+@r+@s)
        Rock.new
      end
    end
  end
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    self.class.name + "  p = " + @p.to_s + ", r = " + @r.to_s + ", s = " + @s.to_s 
  end
  
  ##
  # Método reset
  # Restaura la estrategia a su estado inicial
  def reset
    @p = 0
    @r = 0
    @s = 0 
    srand(SEMILLA)
    @contNil = 0
    self
  end
  
  ##
  # Método Privado sumar
  # Suma uno a @p, @r o @s dependiendo del valor de m
  # +m : movimiento a ser sumado+
  private
  def sumar m
    case m
    when Paper
      @p += 1
    when Rock
      @r += 1
    when Scissors
      @s += 1
    end
  end
end

###############################################################################
###################################EL JUEGO####################################
###############################################################################

class Match
  
  # +jugadores+   : mapa suministrado por el usuario
  # +juego+       : mapa del juego creado a partir del mapa de jugadores
  # +movJ1+       : movimiento del jugador uno
  # +movJ2+       : movimiento del jugador dos
  attr_accessor :jugadores, :juego, :movJ1, :movJ2
  
  ##
  # Método +initialize+
  # Constructor  Match
  # +mapa: mapa suministrado por el usuario+
  def initialize mapa
    raise ArgumentError,'El mapa de los Jugadores no puede ser vacío' unless (not mapa.empty?)
    raise ArgumentError,'Deben haber exactamente 2 jugadores' unless (mapa.size == 2)
    raise ArgumentError,'Una de las Estrategias es invalida' unless (validar_estrategias mapa.values)
    @jugadores = mapa
    @juego =  { @jugadores.keys[0] => 0, @jugadores.keys[1] => 0, "Rondas" => 0}
    @jugadores.values[0] = @jugadores.values[0].reset
    @jugadores.values[1] = @jugadores.values[1].reset
    if (mapa.values[0] == mapa.values[1])
      @movJ1 = @jugadores.values[0].next(nil)
      @jugadores.values[1] = @jugadores.values[1].reset
      @movJ2 = @jugadores.values[1].next(nil)
    else
      @movJ1 = @jugadores.values[0].next(nil)
      @movJ2 = @jugadores.values[1].next(nil)
    end
  end
  
  ##
  # Método to_s
  # Muestra el invocante como un String
  def to_s
    @jugadores.to_s
  end
  
  ##
  # Método rounds
  # Completa n Rondas en el juego
  # +n : numero de rondas a jugarse+
  def rounds n
    i=0
    puntosJugador1 = 0
    puntosJugador2 = 0
    pm1 = @movJ1
    pm2 = @movJ2
    
    while i<n
      puntuacion = pm1.score(pm2)
      puntosJugador1 += puntuacion[0]
      puntosJugador2 += puntuacion[1]
      @movJ1 = @jugadores.values[0].next(pm2)
      @movJ2 = @jugadores.values[1].next(pm1)
      pm1 = @movJ1
      pm2 = @movJ2
      i +=1
    end
    @juego[(@juego.keys[0])] += puntosJugador1
    @juego[(@juego.keys[1])] += puntosJugador2
    @juego[(@juego.keys[2])] += i
    @juego
  end
  
  ##
  # Método upto
  # Se completan X rondas hasta que alguno de los jugadores tenga n ganadas
  # +n : numero de partidas a ganar+
  def upto n
    pm1 = @movJ1
    pm2 = @movJ2
    
    while true
      puntuacion = pm1.score(pm2)
      @juego[(@juego.keys[0])] += puntuacion[0]
      @juego[(@juego.keys[1])] += puntuacion[1]
      @juego[(@juego.keys[2])] += 1
      @movJ1 = @jugadores.values[0].next(pm2)
      @movJ2 = @jugadores.values[1].next(pm1)
      pm1 = @movJ1
      pm2 = @movJ2
      if @juego[(@juego.keys[0])] == n || @juego[(@juego.keys[1])] == n
        break
      end
    end
    @juego
  end
  
  ##
  # Método restart
  # Restaura el juego a su estado inicial
  def restart
    @jugadores.values[0] = @jugadores.values[0].reset
    @jugadores.values[1] = @jugadores.values[1].reset
    @juego =  { @jugadores.keys[0] => 0, @jugadores.keys[1] => 0, "Rondas" => 0}
    @movJ1 = @jugadores.values[0].next(nil)
    @movJ2 = @jugadores.values[1].next(nil)
    self
  end
  
  ##
  # Método Privado validar_estrategias
  # Verifica que todos los elementos sean una estrategia valida
  # +m : lista de posibles estrategia+
  private
  def validar_estrategias m
    esSub = true
    m.each {|x| @EsSub = @EsSub && val_tipo(x)}
    esSub
  end
  
  ##
  # Método Privado val_tipo
  # verifica que x sea una instancia de alguna estrategia valida
  # +x : una posible estrategia+
  def val_tipo x
    es = false
    if (x.instance_of? Uniform) || (x.instance_of? Biased) || (x.instance_of? Mirror) || (x.instance_of? Smart)
      es = true
    end
    es
  end
end#Fin Match
