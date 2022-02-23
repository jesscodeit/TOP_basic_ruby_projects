
class Player
  attr_accessor :wins
  attr_reader :mark

  def initialize(mark)
    @mark = mark
    @wins = 0
  end
end
