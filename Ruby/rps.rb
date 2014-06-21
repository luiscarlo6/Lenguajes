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
  def next m
  end

  def to_s
  end

  def reset
  end
end

class Biased < Strategy
  def next m
  end

  def to_s
  end

  def reset
  end
end

class Mirror < Strategy
  def next m
  end

  def to_s
  end

  def reset
  end
end

class Smart < Strategy
  def next m
  end

  def to_s
  end

  def reset
  end
end
