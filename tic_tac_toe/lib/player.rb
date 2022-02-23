class Player
  attr_accessor :wins, :mark

  def initialize(mark)
    @mark = mark
    @wins = 0
  end
end
