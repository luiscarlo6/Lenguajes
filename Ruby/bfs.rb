# -*- coding: utf-8 -*-
class BinTree
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
  attr_accessor :value, # Valor alamacenado en el nodo
                :children # Arreglo de sucesores GraphNode
  def initialize(v,c)
    @value = v
    @children = c
  end
  
  def each(&b)
    @children.each &b unless @children.nil?
    
  end

  def to_s
    "(#{@value},#{@children.to_s})"
  end
end


  
# a = BinTree.new(1,nil,nil)
# b = BinTree.new(2,nil,nil)
# c = BinTree.new(3,a,b)
# d = GraphNode.new(4,[a,b,c])
# d.each() {|a| puts a}
# puts  c.to_s



