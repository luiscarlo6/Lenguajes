# -*- coding: utf-8 -*-
class BinTree
  include BFS

  attr_accessor :value, # Valor almacenado en el nodo
                :left, # BinTree izquierdo
                :right # BinTree derecho
  def initialize(v,l,r)
    @value = v
    @left  = l
    @right = r
  end
  
  def each(&b)
    if block_given? then
      if not @left.nil?
        yield @left
      end
      if not @right.nil? 
        yield @right
      end 
    else
      raise "No blocks given!"
    end
  end

  def to_s
    #    "#{@value}"
    "(#{@value},#{@left.to_s},#{@right.to_s})"
  end
end


class GraphNode
  include BFS

  attr_accessor :value, # Valor alamacenado en el nodo
               :children # Arreglo de sucesores GraphNode
  def initialize(v,c)
    @value = v
    @children = c
  end
  
  def each(&b)
    @children.each do |e|
      if not e.nil?
        yield e
      end 
    end unless @children.nil?    
  end

  def to_s
    "(#{@value},#{@children.to_s})"
  end
end


module BFS
  
  def find(start,predicate)
    raise "Not implemented yet"
  end
  
  def path(start,predicate)
    raise "Not implemented yet"
  end

  def walk(start,action)
    raise "Not implemented yet"
  end

end
