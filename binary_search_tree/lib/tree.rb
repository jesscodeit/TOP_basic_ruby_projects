require_relative 'node.rb'

class Tree
  attr_reader :root

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
          #matching node confirmed to have two children
          puts "data to be deleted has two children"
          ###### PICK BACK UP HERE AND MAKE IT MATCH THE RIGHT SIDE
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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end