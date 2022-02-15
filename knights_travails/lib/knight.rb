require_relative 'board.rb'

class Knight
  attr_reader :location, :parent_tile

  MOVES = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]

  @@history = []

  def initialize(location, parent_tile = nil)
    @location = location
    @parent_tile = parent_tile
    @@history.push(location)
  end

  def find_child_tiles
    valid_tiles = []

    MOVES.each do |move|
      possible_tile = [(@location[0] + move[0]),(@location[1] + move[1])]
      if inside_bounds?(possible_tile) && !@@history.include?(possible_tile)
        valid_tiles << Knight.new(possible_tile, self)
      end
    end

    valid_tiles
  end

  ## check if location is on board
  def inside_bounds?(tile = [-1, -1])
    tile[0].between?(0,7) && tile[1].between?(0,7) ? true : false
  end
end