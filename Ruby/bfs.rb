# -*- coding: utf-8 -*-
module BFS
  
  def find(start,predicate)
    queue = [start]
    set = [start]
    while not queue.empty?
      t = queue.shift
      if predicate.call(t.value)
        return t
      end
      t.each do |e|
        if not set.include? e
          set << e
          queue << e
        end
      end
    end
    puts "Ningun elemento cumple con el predicado"
  end
  
  def path(start,predicate)
    queue = [start]
    set = [start]
    roads = Hash[start,[start]]
    while not queue.empty?
      t = queue.shift
      puts "t="+t.to_s+" cola ="+queue.to_s+" set="+set.to_s
      if predicate.call(t.value)
        return roads[t]
      end
      t.each do |e|
        if not set.include? e
          roads[e] = roads[t] + [e]
          set << e
          queue << e
        end
      end 
    end
    puts "Ningun elemento cumple con el predicado"
  end

  def walk(start,action)
    queue = [start]
    set = [start]
    list = []
    while not queue.empty?
      t = queue.shift
      action.call(t.value)
      list << t
      t.each do |e|
        if not set.include? e
          set << e
          queue << e
        end
      end 
    end
    return list
  end
end

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
    "#{@value}"
    #"(#{@left.to_s},#{@value},#{@right.to_s})"
  end

  def HacerArbol
    bt8 = BinTree.new(11,nil,nil)
    bt7 = BinTree.new(5,nil,nil)
    bt6 = BinTree.new(6,bt7,bt8)
    bt5 = BinTree.new(3,nil,nil)
    bt1 = BinTree.new(7,bt5,bt6)
    bt4 = BinTree.new(4,nil,nil)    
    bt3 = BinTree.new(9,bt4,nil)
    bt2 = BinTree.new(5,nil,bt3)
    @value = 2
    @left = bt1
    @right = bt2
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
    "#{@value}"
#    "(#{@value},#{@children.to_s})"
  end

  def HacerGrafo
    munchen = GraphNode.new("Munchen",[])
    augsburg = GraphNode.new("Augsburg",[munchen])
    stuttgart = GraphNode.new("Stuttgart",[])
    nurnberg = GraphNode.new("Nürnberg",[munchen,stuttgart])
    erfurt = GraphNode.new("Erfurt",[])
    karlsruhe = GraphNode.new("Karlsruhe",[augsburg])
    kassel = GraphNode.new("Kassel",[munchen])
    wuzburg = GraphNode.new("Wüzburg",[erfurt,nurnberg])
    mannheim = GraphNode.new("Mannheim",[karlsruhe])
    @value = "Frankfurt"
    @children = [mannheim,wuzburg,kassel]
  end
end
