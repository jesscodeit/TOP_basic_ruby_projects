=begin
7 columns, 6 rows
allow players to drop coins into vertical arrays, until array == 6
have an array of possible wins (4 coins in a row)
check for wins 

# welcome message
# display grid

# TURN
# message telling player to pick a column
# recieve input for column
# verify input is a number 1-7
# verify column is not full
# add coin to column, else reprompt player for valid input
# display the grid

# check for win
# check for tie
# end game if either are true

# else if false, switch player turn
# turn for next player

# if win or tie, declare win or tie
# ask to play again
# reset game or end game

# # # private puts/gets:
# display grid
# welcome message
# declare winner
# declare tie
# declare incorrect input
# ask to play again
# new game message
# recieve gets

=end
class Player
  attr_accessor :coin, :wins

  def initialize(coin)
    @coin = coin
    @wins = 0
  end
end

class ConnectFour
  attr_accessor :cage, :last_drop, :player_up

  def initialize
    @cage = clear_cage
    @player1 = Player.new(black_coin)
    @player2 = Player.new(white_coin)
    @player_up = @player1
    @last_drop = 0
  end

  def play_game
    welcome_message
    display_cage
    until game_over?
      switch_player
      turn
    end

    if tie? 
      declare_tie
    elsif winner?
      declare_winner
      @player_up.wins += 1
    end
    puts_win_history

    if play_again?
      @cage = clear_cage
      play_game
    else
      puts_goodbye
    end
  end

  def turn 
    @last_drop = get_play
    add_to_cage(@last_drop)
    display_cage
  end

  def get_play 
    puts_choose_column
    c = get_player_input.to_i

    if c.between?(0,6) && (@cage[c].length) < 6
      c
    else 
      puts_error
      get_play
    end
  end

  def add_to_cage(column)
    @cage[column].push(@player_up.coin)
  end

  def switch_player
    if @player_up == @player1
      @player_up = @player2
    else
      @player_up = @player1
    end
  end

  def play_again?
    ask_to_play_again
    a = get_player_input.to_i

    if a == 1
      true
    elsif a == 2
      false
    else
      puts_error
      play_again?
    end
  end

  def game_over?
    tie? || winner? ? true : false
  end

  def tie?
    @cage.any? { |column| column.length < 6 } ? false : true
  end

  def winner?
    if row_win? || column_win? || diagonal_win?
      true
    else
      false
    end
  end

  def row_win?
    coin = @player_up.coin
    column = @last_drop
    row = @cage[@last_drop].length - 1

    #check across row, leftwise
    c = column
    r = row
    line = 1

    3.times do 
      if c > 0
        c -= 1
      else
        break
      end

      if @cage[c][r] == coin
        line += 1
      else
        break
      end
    end

    #check across row, rightwise
    c = column 
    3.times do
      if c < 6
        c += 1
      else
        break
      end

      if @cage[c][r] == coin
        line += 1
      else
        break
      end
    end

    line >= 4 ? true : false
  end

  def column_win?
    coin = @player_up.coin
    column = @last_drop
    row = @cage[@last_drop].length - 1

    #check down column
    c = column
    r = row
    line = 1

    3.times do 
      if r > 0
        r -= 1
      else
        break
      end

      if @cage[c][r] == coin
        line += 1
      else
        break
      end
    end

    line >= 4 ? true : false
  end

  def diagonal_win?
    coin = @player_up.coin
    column = @last_drop
    row = @cage[@last_drop].length - 1

    #check diagonally, down
    c = column
    r = row
    line = 1

    3.times do 
      if c > 0 && r > 0
        c -= 1
        r -= 1
      else
        break
      end

      if @cage[c][r] == coin
        line += 1
      else
        break
      end
    end

    #check diagonally, up
    c = column 
    r = row
    3.times do
      if c < 6 && r < 5
        c += 1
        r += 1
      else
        break
      end

      if @cage[c][r] == coin
        line += 1
      else
        break
      end
    end

    line >= 4 ? true : false
  end

  def display_cage
    c = @cage
    puts <<~HEREDOC

    . 0    1    2    3    4    5    6  .
    ------------------------------------
    | #{c[0][5] || "  "} | #{c[1][5] || "  "} | #{c[2][5] || "  "} | #{c[3][5] || "  "} | #{c[4][5] || "  "} | #{c[5][5] || "  "} | #{c[6][5] || "  "} |
    ------------------------------------
    | #{c[0][4] || "  "} | #{c[1][4] || "  "} | #{c[2][4] || "  "} | #{c[3][4] || "  "} | #{c[4][4] || "  "} | #{c[5][4] || "  "} | #{c[6][4] || "  "} |
    ------------------------------------
    | #{c[0][3] || "  "} | #{c[1][3] || "  "} | #{c[2][3] || "  "} | #{c[3][3] || "  "} | #{c[4][3] || "  "} | #{c[5][3] || "  "} | #{c[6][3] || "  "} |
    ------------------------------------
    | #{c[0][2] || "  "} | #{c[1][2] || "  "} | #{c[2][2] || "  "} | #{c[3][2] || "  "} | #{c[4][2] || "  "} | #{c[5][2] || "  "} | #{c[6][2] || "  "} |
    ------------------------------------
    | #{c[0][1] || "  "} | #{c[1][1] || "  "} | #{c[2][1] || "  "} | #{c[3][1] || "  "} | #{c[4][1] || "  "} | #{c[5][1] || "  "} | #{c[6][1] || "  "} |
    ------------------------------------
    | #{c[0][0] || "  "} | #{c[1][0] || "  "} | #{c[2][0] || "  "} | #{c[3][0] || "  "} | #{c[4][0] || "  "} | #{c[5][0] || "  "} | #{c[6][0] || "  "} |
    ------------------------------------

    HEREDOC
  end

  def no_coin
    "  "
  end

  def white_coin
    "⚪"
  end

  def black_coin
    "⚫"
  end

  def clear_cage 
    [[], [], [], [], [], [], []]
  end

  def welcome_message
    puts <<~HEREDOC

    Welcome! Let's play Connect Four! 

    Your objective is to connect four of your coins in a line, 
    while stopping your opponent from doing the same. 
    You can connect four vertically, horizontally or diagonally.

    HEREDOC
  end

  def puts_choose_column
    puts <<~HEREDOC

    Player #{@player_up.coin}, choose a column to drop your coin into.
    Make your selection by entering the column number [1-7]:

    HEREDOC
  end

  def puts_error
    puts <<~HEREDOC

    ERROR! That is not a valid input. Please try again.
    HEREDOC
  end

  def get_player_input
    gets.chomp
  end

  def declare_tie
    puts <<~HEREDOC

    What a game! Not every match up will end in a tie...
    HEREDOC
  end

  def declare_winner
    puts <<~HEREDOC

    And we have a winner!!
    Congratulations to Player #{@player_up.coin}, you've won! 
    HEREDOC
  end

  def puts_win_history
    puts <<~HEREDOC
    Historical wins:
    #{@player1.coin}: #{@player1.wins}
    #{@player2.coin}: #{@player2.wins}
    HEREDOC
  end

  def ask_to_play_again
    puts <<~HEREDOC

    Would you like to play again?
    [1] to play again
    [2] to end game

    HEREDOC
  end

  def puts_goodbye
    puts <<~HEREDOC

    Ok. Thanks for playing, have a great day!

    HEREDOC
  end
end