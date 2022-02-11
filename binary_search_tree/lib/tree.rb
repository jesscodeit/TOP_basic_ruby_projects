require_relative 'node.rb'

class Tree
  attr_reader :root, :arr

  def initialize(arr = [])
    @arr = arr.sort.uniq
    @root = build_tree(@arr)
  end

  def build_tree(arr, first = 0, last = arr.length - 1)
    return nil if first > last
    mid = (first + last)/2
    r_node = Node.new(arr[mid])

    r_node.left_child = build_tree(arr, first, mid -1)
    r_node.right_child = build_tree(arr, mid +1, last)

    r_node
  end

  def insert(data, current_node = @root)
    if data == current_node.data
      puts "Data (#{data}) already exists as node in tree."

    elsif data < current_node.data 
      if current_node.left_child == nil
        current_node.left_child = Node.new(data)
      else
        insert(data, current_node.left_child)
      end

    elsif data > current_node.data
      if current_node.right_child == nil
        current_node.right_child = Node.new(data)
      else
        insert(data, current_node.right_child)
      end
    end
  end

  def delete(data, current_node = @root)
    if !@arr.include?(data)
      puts "Data to be deleted (#{data}) does not exist as node in tree."

    elsif data == current_node.data
      puts "data to be deleted is the root"

    elsif data < current_node.data
      if data == current_node.left_child.data
        if current_node.left_child.left_child == nil
        #matching node confirmed to have one child or less 
          if current_node.left_child.right_child == nil
            #matching node confirmed to be a leaf node
            current_node.left_child = nil
          else 
            current_node.left_child = current_node.left_child.right_child
          end

        elsif current_node.left_child.right_child == nil
        #matching node confirmed to have just one child (left)
          current_node.left_child = current_node.left_child.left_child
        
        else
          #matching node confirmed to have two children ####################
          ntd = current_node.left_child

          if ntd.right_child.left_child == nil
            #then right child of node to delete becomes the replacement node
            rplc_n = ntd.right_child
            rplc_n.left_child = ntd.left_child
            current_node.left_child = rplc_n

          else 
            #else search fr replacement node in left children of node to delete's right child
            rc_of_ntd = ntd.right_child

            if rc_of_ntd.left_child.left_child == nil
              #we have found the next biggest node
              rplc_n = rc_of_ntd.left_child

              if rc_of_ntd.left_child.right_child == nil
                #confirmed next largest node doesn't have a right child
                rplc_n.left_child = ntd.left_child
                rplc_n.right_child = ntd.right_child
                current_node.left_child = rplc_n 
                rplc_n.right_child.left_child = nil

              else 
                #else next largest node DOES have a right child.
                r_branch = rplc_n.right_child
                ntd.right_child.left_child = r_branch
                rplc_n.right_child = ntd.right_child
                rplc_n.left_child = ntd.left_child
                current_node.left_child = rplc_n ### this line is where the two sides differ
              end

            else 
              #else we have NOT found next biggest node yet.
              p_nxt_bigst = rc_of_ntd

              #scootch down left branch until finding the next biggest node
              until p_nxt_bigst.left_child.left_child == nil
                p_nxt_bigst = p_nxt_bigst.left_child
              end

              rplc_n = p_nxt_bigst.left_child
              ####  
              if rplc_n.right_child == nil
                #confirmed next largest node doesn't have a right child
                current_node.left_child = rplc_n ### this line is where the two sides differ
                rplc_n.left_child = ntd.left_child
                rplc_n.right_child = ntd.right_child
                p_nxt_bigst.left_child = nil
              else #next largest node DOES have a right child
                r_branch = rplc_n.right_child
                p_nxt_bigst.left_child = r_branch
                rplc_n.right_child = ntd.right_child
                rplc_n.left_child = ntd.left_child
                current_node.left_child = rplc_n  ### this line is where the two sides differ
              end
            end
          end
        end

      else
        delete(data, current_node.left_child)
      end

    elsif data > current_node.data
      if data == current_node.right_child.data
        if current_node.right_child.left_child == nil 
        #matching node confirmed to have one child or less 
          if current_node.right_child.right_child == nil
          #matching node confirmed to be a leaf node
            current_node.right_child = nil
          else
            current_node.right_child = current_node.right_child.right_child
          end

        elsif current_node.right_child.right_child == nil
        #matching node confirmed to have just one child (left)
          current_node.right_child = current_node.right_child.left_child

        else
          #matching node confirmed to have two children
          ntd = current_node.right_child

          if ntd.right_child.left_child == nil
            current_node.right_child.right_child.left_child = current_node.right_child.left_child
            current_node.right_child = current_node.right_child.right_child
            
          else 
            rc_of_ntd = ntd.right_child
            
            if rc_of_ntd.left_child.left_child == nil
              rplc_n = rc_of_ntd.left_child

              if rc_of_ntd.left_child.right_child == nil
                #confirmed next largest node doesn't have a right child
                rplc_n.left_child = ntd.left_child
                rplc_n.right_child = ntd.right_child
                current_node.right_child = rplc_n
                current_node.right_child.right_child.left_child = nil

              else 
                #else next largest node DOES have a right child.
                r_branch = rplc_n.right_child
                ntd.right_child.left_child = r_branch
                rplc_n.right_child = ntd.right_child
                rplc_n.left_child = ntd.left_child
                current_node.right_child = rplc_n
              end

            else 
              #else we haven't hit the next biggest node yet.
              p_nxt_bigst = rc_of_ntd

              until p_nxt_bigst.left_child.left_child == nil
                p_nxt_bigst = p_nxt_bigst.left_child
              end
              rplc_n = p_nxt_bigst.left_child

              if rplc_n.right_child == nil
                #confirmed next largest node doesn't have a right child
                current_node.right_child = rplc_n
                rplc_n.left_child = ntd.left_child
                rplc_n.right_child = ntd.right_child
                p_nxt_bigst.left_child = nil
              else
                r_branch = rplc_n.right_child
                p_nxt_bigst.left_child = r_branch
                rplc_n.right_child = ntd.right_child
                rplc_n.left_child = ntd.left_child
                current_node.right_child = rplc_n
              end
            end
          end
        end
        
      else
        delete(data, current_node.right_child)
      end

    else
      puts "ehh"
    end
  end

  def find(data, current_node = @root)
    if current_node == nil
      puts "Data does not exist as node in tree."
    elsif data == current_node.data
      current_node
    elsif data < current_node.data
      find(data, current_node.left_child)
    else #data > current_node.data
      find(data, current_node.right_child)
    end
  end

  def level_order
    queue = [@root]
    result = []
    
    until queue.empty?
      current_node = queue.shift

      if block_given? 
        yield(current_node)

      else
        result << current_node.data
      end

      unless current_node.left_child == nil
        queue << current_node.left_child
      end

      unless current_node.right_child == nil
        queue << current_node.right_child
      end
    end

    if !block_given? 
      p result
    end
  end

  def inorder(result = [], current_node = @root)
    #left, root, right
    inorder(result, current_node.left_child) if current_node.left_child != nil

    result << current_node.data

    inorder(result, current_node.right_child) if current_node.right_child != nil

    if block_given?
      result.each do |node|
        yield(node)
      end
    else
      result
    end
  end

  def preorder(result = [], current_node = @root)
    #root, left, right
    result << current_node.data

    preorder(result, current_node.left_child) if current_node.left_child != nil

    preorder(result, current_node.right_child) if current_node.right_child != nil

    if block_given?
      result.each do |node|
        yield(node)
      end
    else
      result
    end
  end

  def postorder(result = [], current_node = @root)
    #left, right, root
    postorder(result, current_node.left_child) if current_node.left_child != nil

    postorder(result, current_node.right_child) if current_node.right_child != nil

    result << current_node.data

    if block_given?
      result.each do |node|
        yield(node)
      end
    else
      result
    end
  end

  def height(node)
    lh = 0
    rh = 0
    lm_node = find(node)
    rm_node = find(node)
    

    until lm_node.left_child == nil && lm_node.right_child == nil
      if lm_node.left_child != nil
        lm_node = lm_node.left_child
        lh += 1
      else
        lm_node = lm_node.right_child
        lh += 1
      end
    end

    until rm_node.left_child == nil && rm_node.right_child == nil
      if rm_node.right_child != nil
        rm_node = rm_node.right_child
        rh += 1
      else
        rm_node = rm_node.left_child
        rh += 1
      end
    end
    
    lh >= rh ? lh : rh
  end

  def depth(node)
    d = 0
    current_node = @root
    until current_node.data == node
      if node < current_node.data
        current_node = current_node.left_child
        d += 1
      elsif node > current_node.data
        current_node = current_node.right_child
        d += 1
      end
    end
    puts "depth for #{node} is #{d}."
  end

  def balanced?
    lh = 0
    rh = 0 
    
    unless @root.left_child == nil
      left = @root.left_child.data
      lh = height(left)
    end

    unless @root.right_child == nil
      right = @root.right_child.data
      rh = height(right)
    end

    if lh - rh > 1 || rh - lh > 1
      false
    else
      true
    end
  end

  def rebalance
    if self.balanced?
      puts "Tree is already balanced."

    else
      arr = self.inorder
      @root = build_tree(arr)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end