#!/usr/bin/ruby

###LOS MOVIMIENTOS###
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

###LAS ESTRATEGIAS###
class Strategy
end

class Uniform < Strategy
  attr_accessor :estrategia, :original
  
  def initialize lista
    unless lista.empty?
      @estrategia = lista.uniq
      @original = lista.uniq
    else
      raise "Error: La Lista en Uniform no puede ser vacia"
    end
  end
  
  def next m
  end

  def to_s
    @aux = self.class.name + " ["
    @estrategia.each {|x|@aux = @aux + x.to_s + ", "}
    @aux = @aux.chomp(", ") + " ]"
  end

  def reset
    @estrategia = @original
  end
end

class Biased < Strategy
  attr_accessor :estrategia, :original,:probabilidad
  
   def initialize mapa
    unless mapa.empty?
      @estrategia = mapa
      @original = mapa.clone
      @probabilidad = cal_prob
    else
      raise "Error: El mapa no puede estar vacio"
    end
  end
  
  def next m
  end

  def to_s
    @aux = self.class.name + " {"
    @estrategia.each {|key, value| @aux = @aux + ":#{key} => #{value/@probabilidad.to_f}, " }
    @aux = @aux.chomp(", ") + " }" 
  end

  def reset
    @estrategia = @original
  end
  
  def cal_prob
    @prob = 0
    @estrategia.values.each {|x| @prob = @prob + x}
    @prob
  end
end

class Mirror < Strategy
  attr_accessor :estrategia, :original
  
  def initialize mov
    @estrategia = mov
    @original = mov
  end
  
  def next m
  end

  def to_s
    @aux = self.class.name + "  Movimiento Inicial = " + @estrategia.to_s 
  end

  def reset
    @estrategia = @original
  end
end

class Smart < Strategy
  attr_accessor :p, :r, :s
  
  def initialize
    @p = 0
    @r = 0
    @s = 0 
  end
  
  def next m
  end

  def to_s
    @aux = self.class.name + "  p = " + @p.to_s + ", r = " + @r.to_s + ", s = " + @s.to_s 
  end

  def reset
    @p = 0
    @r = 0
    @s = 0 
  end
end
