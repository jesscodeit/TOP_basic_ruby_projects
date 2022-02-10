require_relative 'class_node.rb'

class LinkedList
  attr_reader :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    new_n = Node.new(value, nil)
    if @head == nil && @tail == nil
      @head = new_n
      @tail = @head
    else
      @tail.next_node = new_n
      @tail = new_n
    end
  end

  def prepnd(value)
    new_n = Node.new(value, nil)
    if @head == nil && @tail == nil
      @head = new_n
      @tail = @head
    else
      new_n.next_node = @head
      @head = new_n
    end
  end

  def pop(current_node = @head)
    if @head == nil
      puts "List is empty."
    elsif @head.next_node == nil
      @head = nil
      @tail = nil
    elsif current_node.next_node.next_node == nil
      current_node.next_node = nil
      @tail = current_node
    else
      pop(current_node.next_node)
    end
  end

  def size(current_node = @head, count = 0)
    if @head == nil && @tail == nil
      0
    elsif current_node.next_node == nil
      count += 1
      count
    else
      count += 1
      size(current_node.next_node, count)
    end
  end

  def contains?(value, current_node = @head)
    if current_node.value == value
      true
    elsif current_node.next_node == nil
      false
    else
      contains?(value, current_node.next_node)
    end
  end

  def find(value)
    if self.contains?(value)
      count = 0
      current_node = @head
      (self.size - 1).times do |node|
        if current_node.value == value 
          puts count
        else
          current_node = current_node.next_node
          count += 1
        end
      end
    else
      puts "nil"
    end
  end

  def at(index)
    current_node = @head
    if index == 0
      current_node.value
    else
      if index.to_i >= self.size
        p "Index is outside of range."
      else
        (index.to_i).times do |node|
          current_node = current_node.next_node
        end
        p current_node.value
      end
    end
  end

  def insert_at(value, index) 
    if index > self.size || index.negative?
      puts "Index is out of range."
    elsif index == size 
      self.append(value)
    elsif index == 0
      self.prepnd(value)
    else
      next_n = @head
      (index.to_i).times do |node|
        next_n = next_n.next_node
      end
      prior_n = @head
      (index.to_i - 1).times do |node|
        prior_n = prior_n.next_node
      end

      new_n = Node.new(value, next_n)
      prior_n.next_node = new_n
    end
  end

  def remove_at(index)
    if index >= self.size || index.negative?
      puts "Index is out of range."
    elsif index == size - 1
      self.pop
    elsif index == 0
      @head = @head.next_node
    else
      next_n = @head
      (index.to_i + 1).times do |node|
        next_n = next_n.next_node
      end
      prior_n = @head
      (index.to_i - 1).times do |node|
        prior_n = prior_n.next_node
      end
      p prior_n.value
      p next_n.value

      prior_n.next_node = next_n
    end
  end

  def to_s(current_node = @head)
    if @head == nil && @tail == nil
      puts "( EMPTY HEAD/TAIL ) -> nil"
    elsif current_node.next_node == nil
      puts "(#{current_node.value}) -> nil"
    else
      print "(#{current_node.value}) -> "
      to_s(current_node.next_node)
    end
  end
end