require_relative 'knight.rb'

class Board
  def initialize
    @board_tiles = [0,1,2,3,4,5,6,7].repeated_permutation(2).to_a
  end

  def find_path(start_tile, end_tile)
    queue = []
    current_tile = Knight.new(start_tile, nil)

    until current_tile.location == end_tile
      current_tile.find_child_tiles.each { |child| queue.push(child) }
      current_tile = queue.shift
    end

    path_arr = make_path_arr(current_tile)
    print_path(start_tile, end_tile, path_arr)
  end

  def make_path_arr(tile, path_arr = [])
    unless tile.parent_tile.nil?
      path_arr << tile.location
      make_path_arr(tile.parent_tile, path_arr)
    else
      return path_arr.reverse
    end
  end

  def print_path(start_tile, end_tile, path_arr)
    puts "It took #{path_arr.length} moves to go from #{start_tile} to #{end_tile}."
    print "Your path was: #{start_tile}"

    path_arr.each do |location| 
      print " to #{location}"
    end
    print ".\n"
  end
end