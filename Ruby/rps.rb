#!/usr/bin/ruby
#####################
###LOS MOVIMIENTOS###
#####################
class Movement
  def to_s
    self.class.name
  end
end

class Rock < Movement
  def score m
    m.vsroca self
  end
  
  def vsroca m
    [0,0]
  end
  
  def vspapel m
    [1,0]
  end
  
  def vstijera m
    [0,1]
  end
end

class Paper < Movement
  def score m
    m.vspapel self
  end
  
  def vsroca m
    [0,1]
  end
  
  def vspapel m
    [0,0]
  end
  
  def vstijera m
    [1,0]
  end
end

class Scissors < Movement
  def score m
    m.vstijera self
  end
  
  def vsroca m
    [1,0]
  end
  
  def vspapel m
    [0,1]
  end
  
  def vstijera m
    [0,0]
  end
end

#####################
###LAS ESTRATEGIAS###
#####################
class Strategy
  SEMILLA = 42
  attr_accessor :jugador
  
  def initialize jug
    @jugador = jug
  end
  
  def to_s
    @jugador.to_s
  end
end

class Uniform < Strategy
  attr_accessor :estrategia, :original, :contNil
  
  def initialize lista
    raise ArgumentError, 'La Lista no puede ser vacia' unless (not lista.empty?)
    @estrategia = lista.uniq
    @original = lista.clone.uniq
    @contNil = 0
  end
  
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
  
  def to_s
    aux = self.class.name + " ["
    @estrategia.each {|x|aux = aux + x.to_s + ", "}
    aux = aux.chomp(", ") + " ]"
  end
  
  def reset
    @estrategia = @original.clone
    @contNil = 0
    self
  end
end

class Biased < Strategy
  attr_accessor :estrategia, :original,:probabilidad, :contNil
  
  def initialize mapa
    raise ArgumentError, 'El mapa no puede ser vacio' unless (not mapa.empty?)
    @estrategia = mapa
    @original = mapa.clone
    cal_prob
    @probabilidad = @estrategia.values.sort
    @contNil = 0
  end
  
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
  
  def to_s
    aux = self.class.name + " {"
    @estrategia.each {|key, value| aux = aux + ":#{key} => #{value}, " }
    aux = aux.chomp(", ") + " }"
  end
  
  def reset
    @estrategia = @original.clone
    cal_prob
    @contNil = 0
    self
  end
  
  private
  def cal_prob
    prob = 0
    @estrategia.values.each {|x| prob = prob + x}
    
    if prob !=0
      @estrategia.each {|key, value| @estrategia[key] = value/prob.to_f}
    end
  end
end

class Mirror < Strategy
  attr_accessor :estrategia, :original, :control, :anterior, :contNil
  
  def initialize mov
    @estrategia = mov
    @original = mov.clone
    @control = true
    @anterior = nil
    @contNil = 0
  end
  
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
  
  def to_s
    self.class.name + "  Movimiento Inicial = " + @estrategia.to_s 
  end
  
  def reset
    @estrategia = @original.clone
    @control = true
    @anterior = nil
    @contNil = 0
    self
  end
end

class Smart < Strategy
  attr_accessor :p, :r, :s, :contNil
  
  def initialize
    @p = 0
    @r = 0
    @s = 0 
    @contNil = 0
    srand(SEMILLA)
  end
  
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
  
  def to_s
    self.class.name + "  p = " + @p.to_s + ", r = " + @r.to_s + ", s = " + @s.to_s 
  end
  
  def reset
    @p = 0
    @r = 0
    @s = 0 
    srand(SEMILLA)
    @contNil = 0
    self
  end
  
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

###################
######EL JUEGO#####
###################

class Match
  attr_accessor :jugadores, :juego, :movJ1, :movJ2
  
  def initialize mapa
    raise ArgumentError, 'El mapa de los Jugadores no puede ser vacio' unless (not mapa.empty?)
    raise ArgumentError, 'Deben haber exactamente 2 jugadores' unless (mapa.size == 2)
    raise ArgumentError, 'Una de las Estrategias es invalida' unless (validar_estrategias mapa.values)
    @jugadores = mapa
    @juego =  { @jugadores.keys[0] => 0, @jugadores.keys[1] => 0, "Rondas" => 0}
    @jugadores.values[0].reset
    @jugadores.values[1].reset
    @movJ1 = @jugadores.values[0].next(nil)
    @movJ2 = @jugadores.values[1].next(nil)
#     puts "Estrategia 1 =  " + @jugadores[(@jugadores.keys[0])].to_s
#     puts "Estrategia 2 =  " + @jugadores[(@jugadores.keys[1])].to_s
#     @movJ1 = @jugadores.values[0].next(nil)
#     @movJ2 = @jugadores[(@jugadores.keys[1])].next(nil)
#     puts "\n\nmovJ1 = " + @jugadores[(@jugadores.keys[0])].next(nil).to_s
#     puts "Estrategia 2" + @jugadores.values[1].to_s
  end
  
  def to_s
    @jugadores.to_s #+ "\n\nmovJ1 = " + @movJ1.to_s + "movJ2 = " + @movJ2.to_s + "  JUEGO" + @juego.to_s 
  end
  
  def rounds n
    i=0
    puntosJugador1 = 0
    puntosJugador2 = 0
#      puts "Entrando:\n\nmovJ1 = " + @movJ1.to_s
#       puts "movJ2 = " + @movJ2.to_s
#     strateg =@jugadores.values
    pm1 = @movJ1
    pm2 = @movJ2
    
    while i<n
#       puts "movJ1 = " + @movJ1.to_s
#       puts "movJ2 = " + @movJ2.to_s
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
  
  def upto n
#     strateg =@jugadores.values
    pm1 = @movJ1
    pm2 = @movJ2
    
    while true
      puntuacion = pm1.score(pm2)
      @juego[(@juego.keys[0])] += puntuacion[0]
      @juego[(@juego.keys[1])] += puntuacion[1]
      @juego[(@juego.keys[2])] += 1
#       @movJ1 = strateg[0].next(pm2)
#       @movJ2 = strateg[1].next(pm1)
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
  
  def restart
#     @jugadores = @jugadores.each {|key, value| @jugadores[key] = @jugadores[key].reset}
    @jugadores.values[0].reset
    @jugadores.values[1].reset
    @juego =  { @jugadores.keys[0] => 0, @jugadores.keys[1] => 0, "Rondas" => 0}
    @movJ1 = @jugadores.values[0].next(nil)
    @movJ2 = @jugadores.values[1].next(nil)
    self
  end
  
  
  private
  def validar_estrategias m
    esSub = true
    m.each {|x| @EsSub = @EsSub && val_tipo(x)}
    esSub
  end
  
  def val_tipo x
    es = false
    if (x.instance_of? Uniform) || (x.instance_of? Biased) || (x.instance_of? Mirror) || (x.instance_of? Smart)
      es = true
    end
    es
  end
end#Fin Match
