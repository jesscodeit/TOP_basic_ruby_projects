class Board
  attr_accessor :board

  def initialize
    @board = [0,1,2,3,4,5,6,7].repeated_permutation(2).to_a
  end
end