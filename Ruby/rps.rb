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

# class Match
#   attr_accessor :jugadores
#   
#   def initialize mapa
#     raise ArgumentError, 'El mapa de los Jugadores no puede ser vacio' unless (not mapa.empty?)
#     raise ArgumentError, 'Deben haber exactamente 2 jugadores' unless (mapa.size == 2)
#     raise ArgumentError, 'Una de las Estrategias es invalida' unless (validar_estrategias mapa.values)
#     @jugadores = mapa
#   end
#   
#   def to_s
#       @jugadores.to_s
#   end
#   
#   private
#   def validar_estrategias m
#     esSub = true
#     m.each {|x| @EsSub = @EsSub && val_tipo(x)}
#     esSub
#   end
#   
#   def val_tipo x
#     es = false
#     if (x.instance_of? Uniform) || (x.instance_of? Biased) || (x.instance_of? Mirror) || (x.instance_of? Smart)
#       es = true
#     end
#     es
#   end
# end#Fin Match



class Match 
  attr_reader :mapa, :ronda
  def initialize (mapa,ronda={})
    if mapa.empty? then
      raise "No puede ser vacio "
    else
      if mapa.length == 2 then
        if self.chequeo(mapa.values[1]) and
           self.chequeo(mapa.values[1]) then
              @mapa = Hash.new
              @ronda = Hash.new
              @ronda = {"0"=> 0,"1" => 0,"Rondas" =>0}
              @mapa = mapa
        else
          raise "No esta definida al menos una estrategia"
        end
      else
        #No hay 2 jugadores exactos
        raise "No hay 2 jugadores exactos"
      end
    end
  end
  
  def to_s
    @mapa.each_pair do |key, value|
    end
  end
  
  def chequeo m
    if m.instance_of? Uniform or m.instance_of? Biased or m.instance_of? Mirror or m.instance_of? Smart
      return true
    end
    false
  end
  
  def rounds n
    rondas = n
    ptsacum1 = 0
    ptsacum2 = 0
    mov1 = Paper.new
    mov2 = Rock.new
    while n != 0 do
      mov1 =  @mapa.values[0].next(mov2)
      mov2 =  @mapa.values[1].next(mov1)
      puts "mov1=" + mov1.to_s + " mov2=" + mov2.to_s
      puntos = mov1.score(mov2)
      ptsacum1 += puntos[0]
      ptsacum2 += puntos[1]
      n = n-1
    end
    ptsacum1 += @ronda.values[0]
    ptsacum2 += @ronda.values[1]
    rondas += @ronda.values[2]  
    @ronda = {@mapa.keys[0] => ptsacum1, @mapa.keys[1] => ptsacum2, "Rondas" => rondas}
    
  end
  
   def upto n
    rondas = 0
    ptsacum1 = 0
    ptsacum2 = 0
    rondasaux = 0
    while n != rondas do
      mov1,mov2 = @mapa.values[0].next(mov2),@mapa.values[1].next(mov1)
      puntos = mov1.score(mov2)
      ptsacum1 += puntos[0]
      ptsacum2 += puntos[1]
      if ptsacum1 != ptsacum2 then
        rondas += 1
      end
      rondasaux += 1
    end
    ptsacum1 += @ronda.values[0]
    ptsacum2 += @ronda.values[1]
    rondasaux += @ronda.values[2]
    @ronda = {@mapa.keys[0] => ptsacum1, @mapa.keys[1] => ptsacum2, "Rondas" => rondasaux}
    
  end
 
  def restart
    @mapa.values[0].reset
    @mapa.values[1].reset
    @ronda = {"0"=> 0,"1" => 0,"Rondas" =>0}
    "Juego Reiniciado"
  end
 
  
end  