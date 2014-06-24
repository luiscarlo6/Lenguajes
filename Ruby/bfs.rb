# -*- coding: utf-8 -*-
# Éste archivo contiene implementación de +arbol binario+,
# implementación de +grafo+, y recorridos BFS sobre ellos

##
# Módulo: BFS
# Éste módulo contiene tres maneras de hacer un recorrido BFS sobre una clase
# que represente alguna abstraccion de un grafo, tenga un atributo +value+ y
# tenga un método +each+ que reciba un bloque para iterar sobre sus hijos
module BFS
  
  ##
  # Método find
  # Realiza una busqueda BFS a partir del objeto +start+ hasta encontrar el
  # primer objeto que cumpla con el predicado +predicate+, y lo retorna. Si no
  # encuentra retorna +objeto indefinido+
  def find(start,predicate)
    queue = [start] 
    set   = [start] #Conjunto de elmentos ya +visitados+
    while not queue.empty?
      t = queue.shift
      if predicate.call(t.value)
        return t
      end
      t.each do |e|
        if not set.include? e
          set   << e
          queue << e
        end
      end
    end
    puts "Ningun elemento cumple con el predicado"
  end
  

  ##
  # Método path
  # Realiza una busqueda BFS a partir del objeto +start+ hasta encontrar el
  # primer objeto que cumpla con el predicado +predicate+. Retorna el camino
  # desde +start+ hasta el objeto encontrado. Si no encuentra retorna
  # +objeto indefinido+
  def path(start,predicate)
    queue = [start]
    set   = [start]             #Conjunto de elementos ya +visitados+
    roads = Hash[start,[start]] #Hash de caminos: nodo -> [nodo]
    while not queue.empty?
      t = queue.shift
      if predicate.call(t.value)
        return roads[t]
      end
      t.each do |e|
        if not set.include? e
          roads[e]  = roads[t] + [e]
          set      << e
          queue    << e
        end
      end 
    end
    puts "Ningun elemento cumple con el predicado"
  end

  ##
  # Método walk
  # Realiza una busqueda BFS a partir del objeto +start+ hasta agotar todo el
  # espacio de búsqueda, ejecutando +action+ sobre cada nodo visitado. Retorna
  # un +Array+ con los los nodos visitados. Si se omite +action+ retorna un
  # +Array+ con los nodos visitados
  def walk(start,action)
    queue = [start]
    set   = [start]  #Conjunto de elementos ya +visitados+
    while not queue.empty?
      t = queue.shift
      action.call(t.value)
      t.each do |e|
        if not set.include? e
          set   << e
          queue << e
        end
      end 
    end
    return set
  end
end

##
# Clase BinTree
# Representa árboles binarios
class BinTree
  include BFS
  # +value+: Valor almacenado en el nodo
  attr_accessor :value
  # +left+ : BinTree izquierdo
  attr_accessor :left 
  # +right+: BinTree derecho
  attr_accessor :right 
  
  ##
  # Método +initialize+
  # Constructor de un BinTree con tres parámetros
  # +v:value+, +l:left+, +r:right+
  def initialize(v,l,r)
    @value = v
    @left  = l
    @right = r
  end
  
  ##
  # Método each 
  # recibe un bloque +b+ que será utilizado para iterar sobre los hijos del nodo,
  # cuando estén definidos
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
end

##
# Clase GraphNode
# Representa grafos arbitrarios a partir de un nodo específico
class GraphNode
  include BFS


  # +children+: Arreglo de sucesores GraphNode
  attr_accessor :value
  # +value+   : Valor almacenado en el nodo
  attr_accessor :children
  
  ##
  # Método +initialize+
  # Constructor de un GraphNode con dos parámetros
  # +v:value+, +c:children+
  def initialize(v,c)
    @value = v
    @children = c
  end

  ##
  # Método each 
  # recibe un bloque +b+ que será utilizado para iterar sobre los hijos del nodo,
  # cuando estén definidos  
  def each(&b)
    @children.each do |e|
      if not e.nil?
        yield e
      end 
    end unless @children.nil?    
  end
end
