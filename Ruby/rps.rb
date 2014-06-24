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
  attr_accessor :estrategia, :original

  def initialize lista
    raise ArgumentError, 'La Lista no puede ser vacia' unless (not lista.empty?)
    @estrategia = lista.uniq
    @original = lista.clone.uniq
  end

  def next m
    temp = @estrategia.first
    @estrategia = @estrategia.rotate
    temp
  end

  def to_s
    aux = self.class.name + " ["
    @estrategia.each {|x|aux = aux + x.to_s + ", "}
    aux = aux.chomp(", ") + " ]"
  end

  def reset
    @estrategia = @original.clone
  end
end

class Biased < Strategy
  attr_accessor :estrategia, :original,:probabilidad

  def initialize mapa
    raise ArgumentError, 'El mapa no puede ser vacio' unless (not mapa.empty?)
    @estrategia = mapa
    @original = mapa.clone
    cal_prob
    @probabilidad = @estrategia.values.sort
  end

  def next m
    tmp = @probabilidad.first
    @probabilidad = @probabilidad.rotate
    valor = @estrategia.key(tmp)
#     gen_inst @valor
    valor
  end

  def to_s
    aux = self.class.name + " {"
    @estrategia.each {|key, value| aux = aux + ":#{key} => #{value}, " }
    aux = aux.chomp(", ") + " }"
  end

  def reset
    @estrategia = @original
    cal_prob
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
  attr_accessor :estrategia, :original, :control, :anterior

  def initialize mov
    @estrategia = mov
    @original = mov.clone
    @control = true
    @anterior = nil
  end

  def next m
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

  def to_s
    self.class.name + "  Movimiento Inicial = " + @estrategia.to_s 
  end

  def reset
    @estrategia = @original.clone
  end
end

class Smart < Strategy
  attr_accessor :p, :r, :s

  def initialize
    @p = 0
    @r = 0
    @s = 0 
    srand(SEMILLA)
  end

  def next m
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

  def to_s
    self.class.name + "  p = " + @p.to_s + ", r = " + @r.to_s + ", s = " + @s.to_s 
  end

  def reset
    @p = 0
    @r = 0
    @s = 0 
    srand(SEMILLA)
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
  attr_accessor :jugadores
  
  def initialize mapa
    raise ArgumentError, 'El mapa de los Jugadores no puede ser vacio' unless (not mapa.empty?)
    raise ArgumentError, 'Deben haber exactamente 2 jugadores' unless (mapa.size == 2)
    raise ArgumentError, 'Una de las Estrategias es invalida' unless (validar_estrategias mapa.values)
    @jugadores = mapa
  end
  
  def to_s
      @jugadores.to_s
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